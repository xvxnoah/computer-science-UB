-- This script deletes everything in your database
\set QUIET true
SET client_min_messages TO WARNING; -- Less talk please.
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;
GRANT ALL ON SCHEMA public TO CURRENT_USER;
\set ON_ERROR_STOP ON
SET client_min_messages TO NOTICE; -- More talk
\set QUIET false


--------------------------------------------------------------------------------
-- Provided tables
CREATE TABLE Artists(
    name TEXT PRIMARY KEY
);
CREATE TABLE Songs(
    title TEXT PRIMARY KEY,
    length INT NOT NULL,
    artistName TEXT NOT NULL,
    FOREIGN KEY (artistName) REFERENCES Artists(name),
    CONSTRAINT SongTitleAndArtistNameIsUnique UNIQUE (title, artistName)
    /* ^ CONSTRAINT is just a way of giving a name to a constrainnt, 
         used in error messages */
);
CREATE TABLE Playlists (
    id TEXT PRIMARY KEY,
    name TEXT,
    owner TEXT
);

CREATE TABLE PlaylistSongs (
    playlist TEXT REFERENCES Playlists(id),
    song TEXT,
    artist TEXT,
    position INTEGER,
    FOREIGN KEY (song,artist) REFERENCES Songs(title,artistName),
    PRIMARY KEY (playlist,position) DEFERRABLE
    /* If we declare a constraint to be DEFERRABLE, then we have the option of 
    having it wait until the transaction is completed before checking the 
    constraint. */
);


--------------------------------------------------------------------------------
-- Some data
INSERT INTO Artists VALUES ('ABBA');
INSERT INTO Artists VALUES ('John Lundvik');
INSERT INTO Artists VALUES ('Aerosmith');
INSERT INTO Artists VALUES ('The Beatles');
INSERT INTO Songs VALUES ('Dancing Queen'    , 232, 'ABBA');
INSERT INTO Songs VALUES ('Too late for love', 187, 'John Lundvik');
INSERT INTO Songs VALUES ('Pink'             , 100, 'Aerosmith');
INSERT INTO Songs VALUES ('Yellow submarine' , 200, 'The Beatles');
INSERT INTO Songs VALUES ('Yesterday'        , 153, 'The Beatles');
INSERT INTO Playlists VALUES ('M123','Mix','Alice');

-- Check the data
SELECT * FROM Artists;
SELECT * FROM Songs;
SELECT * FROM Playlists;
SELECT * FROM PlaylistSongs;

--------------------------------------------------------------------------------
-- 1.1 Constraints
-- (1): Every song in the playlist exist? Yes, by the foreign key in PlaylistSongs.
-- ERROR:  insert or update on table "playlistsongs" violates foreign key constraint "playlistsongs_song_artist_fkey"
-- DETAIL:  Key (song, artist)=(Macarena, Los del rio) is not present in table "songs".
-- I omit the following to not get an error.
-- INSERT INTO PlaylistSongs VALUES ('M123','Macarena', 'Los del rio', 1);

-- (2): All playlist of the same owner have different names? Yes, because if we try to add a playlist with the same name
-- we get an error: ERROR:  duplicate key value violates unique constraint "playlists_pkey"
-- DETAIL:  Key (id)=(PL001) already exists.
INSERT INTO Playlists VALUES ('PL001','jazz1','Joe');
INSERT INTO Playlists VALUES ('PL002','jazz1','Joe');

-- (3): All positions in a playlist are unique? Yes, because if we try to add songs in the same position we get an error:
-- ERROR:  duplicate key value violates unique constraint "playlistsongs_pkey"
-- DETAIL:  Key (playlist, "position")=(PL001, 1) already exists.
-- I omit the following to not get an error.
-- INSERT INTO PlaylistSongs VALUES ('PL001','Too late for love', 'John Lundvik',1);
-- INSERT INTO PlaylistSongs VALUES ('PL001','Dancing Queen', 'ABBA',1);

-- (4) Are the positions listed in order 1,2,3 ... with no numbers missing? False, because the position is an integer
-- If we wanted the positions to be listed in order with no numbers missing the positon attribute should be serial and we won't give it as a parameter.
INSERT INTO PlaylistSongs VALUES ('PL001','Yesterday','The Beatles', 7);
INSERT INTO PlaylistSongs VALUES ('PL001','Pink', 'Aerosmith', 3);

--------------------------------------------------------------------------------
-- 1.2 Views
/*
Create a view that for a playlist with id M123, shows the content of the 
playlist with the following layout:

 position |       song        |    artist    | length 
----------+-------------------+--------------+--------
        1 | Dancing Queen     | ABBA         |    232
        2 | Too late for love | John Lundvik |    187

Schema reminder:
Artists(_name);
Songs(_title_, length, artistName)
  artistName -> Artists.name
  UNIQUE (title, artistName)
Playlists (_id,name,owner)
PlaylistSongs (_playlist, song, artist, _position)
    (song,artist) -> Songs(title,artistName),
*/

INSERT INTO PlaylistSongs VALUES ('M123','Too late for love', 'John Lundvik', 2);
INSERT INTO PlaylistSongs VALUES ('M123','Dancing Queen', 'ABBA', 1);

CREATE VIEW PlaylistContents AS 
    SELECT position, song, artist, length
    FROM PlaylistSongs JOIN Songs ON (song = title)
    WHERE playlist = 'M123'
    ORDER BY position ASC;

SELECT * FROM PlaylistContents;

-- Another option:
CREATE OR REPLACE VIEW PlaylistM123 AS (
    SELECT position, song, artist, length
    FROM PlaylistSongs, Songs
    WHERE playlist = 'M123'
        AND song = title
        AND artist = artistName
    -- [how to order?]
    ORDER BY position
);

-- 1.3 Triggers
/* 
Create a trigger that enables directly building the playlist M123 via the view defined in the previous question. The behaviour should be as follows:
    Insertion of (position, song, artist, length) ni M123 means an insert ni PlaylistSongs such that
        - the song and artist are inserted as they are given by the user
        - the length is ignored (even fi it contradicts the Songs table)
        - the position given by the user is respected, at the same time main- taining the sequential order 1, 2, 3, . . . of the playlist

Maintaining the sequential order implies the following: assume that the po- sitions in the old playlist are 1,2.3.4. Then
    • if the user inserts in the next position, 5, then 5 is also used as the position of the row inserted to the table
    • if it is larger, say, 8 then the position of the row inserted to the table is still 5
    • if it is smaller, say 3, then the position of the row inserted is 3, but the positions of the old rows 3 and 4 are changed to 4 and 5, respectively
*/

CREATE FUNCTION TriggerM123 ()
    RETURNS trigger AS $$
    DECLARE maxPos INT; -- Variable to store intermediate results

    BEGIN
        -- Compute max position
        SELECT MAX(position) INTO maxPos FROM PlaylistM123;

        -- d) newPos > maxPos
        IF (NEW.position > maxPos)
        THEN --> insert (maxPos + 1, aSong, ...)
            INSERT INTO PlaylistSongs VALUES('M123', NEW.song, NEW.artist, maxPos + 1);
        
        ELSE -- e) newPost <= maxPos
             -- 1. Update all positions >= newPos
             UPDATE PlaylistSongs
                -- DEFEERRABLE (line 38) waits until all positions are updated to check their uniqueness within the playlist
                SET position = position + 1
                WHERE position >= NEW.position AND playlist = 'M123';
            -- 2. Insert (newPos, aSong, ...)
            INSERT INTO PlaylistSongs VALUES('M123', NEW.song, NEW.artist, NEW.position);
        END IF;

        -- Bonus: Prevent negative positions
        -- Note that this will rollback any update inserts performed earlier!
        IF (NEW.position <= 0) THEN
        RAISE EXCEPTION 'negative position!!!';
        END IF;
    
        RETURN NEW;
    END;
    $$ LANGUAGE plpgsql;

CREATE TRIGGER insertM123
    INSTEAD OF INSERT ON PlaylistM123
    FOR EACH ROW
    EXECUTE PROCEDURE TriggerM123();

-- newPos > maxPos
INSERT INTO PlaylistM123 VALUES(8, 'Yellow submarine', 'The Beatles', 210);

-- newPos <= maxPos
INSERT INTO PlaylistM123 VALUES(2, 'Yesterday', 'The Beatles', 153);

SELECT * FROM PlaylistM123;

-- Test a negative position
INSERT INTO PlaylistM123 VALUES(-2, 'Pink', 'Aerosmith', 153);