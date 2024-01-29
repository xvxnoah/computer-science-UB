import enum

from sqlalchemy import Boolean, MetaData, DateTime, Column, ForeignKey, Integer, String, Date, Float, Enum, \
    UniqueConstraint, Table
from sqlalchemy.orm import relationship

from database import Base

categories_list = ("Senior", "Junior")
sports_list = ("Volleyball", "Football", "Basketball", "Futsal")

Category = enum.Enum("Category", {item: item for item in categories_list})
Sport = enum.Enum("Sport", {item: item for item in sports_list})


class Team(Base):
    __tablename__ = 'teams'  # This is table name

    id = Column(Integer, primary_key=True)
    name = Column(String(30), unique=True, nullable=False, index=True)
    country = Column(String(30), nullable=False)
    description = Column(String(100))


teams_in_competitions = Table("teams_in_competitions", Base.metadata,
                              Column("id", Integer, primary_key=True),
                              Column("team_id", Integer, ForeignKey("teams.id")),
                              Column("competition_id", Integer, ForeignKey("competitions.id")))

matches_in_competitions = Table("matches_in_competitions", Base.metadata,
                                Column("id", Integer, primary_key=True),
                                Column("match_id", Integer, ForeignKey("matches.id")),
                                Column("competition_id", Integer, ForeignKey("competitions.id")))


class Competition(Base):
    __tablename__ = 'competitions'  # This is table name
    __table_args__ = (UniqueConstraint('name', 'category', 'sport'),)

    id = Column(Integer, primary_key=True)
    name = Column(String(30), nullable=False)
    category = Column(Enum(*categories_list), nullable=False)
    sport = Column(Enum(*sports_list), nullable=False)
    teams = relationship("Team", secondary=teams_in_competitions, backref="competitions")
    matches = relationship("Match", secondary=matches_in_competitions, back_populates="competition")


class Match(Base):
    __tablename__ = 'matches'  # This is table name
    __table_args__ = (UniqueConstraint('local_id', 'visitor_id', 'competition_id', 'date'),)

    # Columnes de la taula
    id = Column(Integer, primary_key=True)
    date = Column(DateTime, nullable=False)
    price = Column(Float, nullable=False)
    total_available_tickets = Column(Integer, default=100)

    # Foreign keys
    local_id = Column(Integer, ForeignKey("teams.id"), nullable=False)
    visitor_id = Column(Integer, ForeignKey("teams.id"), nullable=False)
    competition_id = Column(Integer, ForeignKey("competitions.id"), nullable=False)

    # Relationships
    competition = relationship("Competition", back_populates="matches")
    local = relationship("Team", foreign_keys=local_id)
    visitor = relationship("Team", foreign_keys=visitor_id)


class Parent(Base):
    __tablename__ = 'parent'
    id = Column(Integer, primary_key=True)
    child_id = Column(Integer, ForeignKey('child.id'))
    child = relationship("Child")


class Child(Base):
    __tablename__ = 'child'
    id = Column(Integer, primary_key=True)


class Account(Base):
    __tablename__ = 'accounts'

    username = Column(String(30), primary_key=True, unique=True, nullable=False)
    password = Column(String(), nullable=False)
    # 0 not admin/ 1 is admin
    is_admin = Column(Integer, nullable=False)
    available_money = Column(Float, nullable=False)
    orders = relationship('Order', backref='orders', lazy=True, cascade="all, delete-orphan")

    def __init__(self, username, available_money=200, is_admin=0):
        self.username = username
        self.available_money = available_money
        self.is_admin = is_admin


class Order(Base):
    __tablename__ = 'orders'

    id = Column(Integer, primary_key=True)
    username = Column(String(30), ForeignKey('accounts.username'), nullable=False)
    match_id = Column(Integer, nullable=False)
    tickets_bought = Column(Integer, nullable=False)

    def __init__(self, match_id, tickets_bought):
        self.match_id = match_id
        self.tickets_bought = tickets_bought


