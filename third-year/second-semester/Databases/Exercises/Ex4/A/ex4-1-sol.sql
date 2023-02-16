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
    /* If we declare a constraint to be DEFERRABLE, then we have the option of having it wait until the transaction is completed before checking the 
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

--------------------------------------------------------------------------------
-- 1.1 Constraints

-- (1): Every song in the playlist exist?
-- INSERT INTO PlaylistSongs VALUES ('M123','Macarena', 'Los del rio', 1);

-- (2): All playlist of the same owner have different names? 
INSERT INTO Playlists VALUES ('PL001','jazz1','Joe');
INSERT INTO Playlists VALUES ('PL002','jazz1','Joe');

-- (3): All positions in a playlist are unique? 
INSERT INTO PlaylistSongs 
       VALUES ('PL001','Too late for love', 'John Lundvik',1);
-- INSERT INTO PlaylistSongs 
--        VALUES ('PL001','Dancing Queen', 'ABBA',1);
-- (4) Are the positions listed in order 1,2,3 ... with no numbers missing?
SELECT * FROM PlaylistSongs;
INSERT INTO PlaylistSongs VALUES ('PL001','Yesterday','The Beatles', 7);
INSERT INTO PlaylistSongs VALUES ('PL001','Pink'     ,'Aerosmith'  , 3);

--------------------------------------------------------------------------------
-- VIEWS

-- 1.2 Create a view that for a playlist with id M123, shows the content of the playlist with the following layout:

/*
 position |       song        |    artist    | length 
----------+-------------------+--------------+--------
        1 | Dancing Queen     | ABBA         |    232
        2 | Too late for love | John Lundvik |    187
*/

INSERT INTO PlaylistSongs 
       VALUES ('M123','Too late for love', 'John Lundvik', 2);
INSERT INTO PlaylistSongs 
       VALUES ('M123','Dancing Queen'    , 'ABBA'        , 1);

CREATE OR REPLACE VIEW PlaylistM123 AS (
    SELECT position, song, artist, length
    FROM PlaylistSongs, Songs
    WHERE playlist = 'M123'
        AND song = title
        AND artist = artistName
    -- [how to order?]
    ORDER BY position
);

SELECT * FROM PlaylistM123;

--------------------------------------------------------------------------------
-- 1.3 Triggers

-- Create trigger to insert songs in the playlists M123 via PlaylistM123 view. -- The positions of the playlist must be sequential but they need to respect -- user's assigned positions

/*
NEW = (newPos, aSong, anArtits, aLen)

how do we know what's the nextPos? = maxPos + 1

a) newPos = maxPos + 1 ---> insert (maxPos + 1, aSong, ...)
b) newPos > maxPos + 1 ---> insert (maxPos + 1, aSong, ...)
c) newPos < maxPos + 1 ---> 1. Update all positions >= newPos
                            2. insert (newPos, aSong, ....)

a) & b) can be merged: newPos >= maxPos + 1 ---> (maxPos + 1, aSong, ...)

n >= m + 1 ---> n > m  Example: 5 >= (4+1) ---> 5 > 4
d) newPos > maxPos ---> (maxPos + 1, aSong, ...)

n < m + 1 ---> n <= m Example: 3 < (3+1) ---> 3 <= 3
e) newPos <= maxPos ---> 1. Update all positions >= newPos
                         2. insert (newPos, aSong, ....)

*/

CREATE OR REPLACE FUNCTION fun_insertM123 ()
    RETURNS TRIGGER AS $$
    DECLARE maxPos INT; -- variable to store intermediate results
BEGIN
    -- compute max position
    SELECT COUNT(*) INTO maxPos FROM PlaylistM123;

    -- d) newPos > maxPos
    IF (NEW.position > maxPos)
    THEN ---> insert (maxPos + 1, aSong, ...)
         INSERT INTO PlaylistSongs 
                VALUES ('M123', NEW.song, NEW.artist, maxPos + 1);
    ELSE -- e) newPos <= maxPos
         -- 1. Update all positions >= newPos
         UPDATE PlaylistSongs
            -- DEFERRABLE (line 38) waits until all positions are updated to 
            -- check their uniqueness within the playlist
            SET position = position + 1
            WHERE position >= NEW.position AND playlist='M123';    
         -- 2. insert (newPos, aSong, ....)
         INSERT INTO PlaylistSongs 
                VALUES ('M123', NEW.song, NEW.artist, NEW.position);
    END IF;
    
    -- Bonus: Prevent negative positions
    -- Note that this will rollback any updates inserts performed earlier!
    IF (NEW.position <= 0) THEN
        RAISE EXCEPTION 'negative position!!!';
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insertM123
    INSTEAD OF INSERT ON PlaylistM123
    FOR EACH ROW
    EXECUTE PROCEDURE fun_insertM123();

-- newPos > maxPos
INSERT INTO PlaylistM123 VALUES (8, 'Yellow submarine', 'The Beatles', 210);
-- newPos <= maxPos
INSERT INTO PlaylistM123 VALUES (2, 'Yesterday', 'The Beatles', 153);

SELECT * FROM PlaylistM123;

-- Test a negative position
INSERT INTO PlaylistM123 VALUES (-2, 'Pink', 'Aerosmith', 153);

