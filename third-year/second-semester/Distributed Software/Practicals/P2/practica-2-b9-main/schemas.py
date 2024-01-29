import enum
from models import sports_list, categories_list
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


class TeamBase(BaseModel):
    name: str
    country: str
    description: Optional[str] = None


class TeamCreate(TeamBase):
    pass


class TeamUpdate(TeamBase):
    pass


class Team(TeamBase):
    id: int

    class Config:
        orm_mode = True


class CompetitionBase(BaseModel):
    name: str
    category: enum.Enum('category', dict(zip(categories_list, categories_list)))
    sport: enum.Enum('sport', dict(zip(sports_list, sports_list)))
    teams: List[Team] = []


class CompetitionCreate(CompetitionBase):
    pass


class Competition(CompetitionBase):
    id: int

    class Config:
        orm_mode = True


class OrderBase(BaseModel):
    match_id: int
    tickets_bought: int


class OrderCreate(OrderBase):
    pass


class Order(OrderBase):
    id: int

    class Config:
        orm_mode = True


class MatchBase(BaseModel):
    date: datetime
    price: float
    local: Team
    visitor: Team
    competition: Competition
    total_available_tickets: int


class AccountBase(BaseModel):
    username: str = Field(..., description="username")
    is_admin: int = Field(..., description="indicates if the user is an admin or not")
    available_money: float = Field(..., description="available money in user's account")
    orders: List[Order] = []

class AccountUpdate(BaseModel):
    available_money: Optional[float] 
    orders: Optional[List[OrderBase]] 

class AccountResponse(BaseModel):
    username: str
    available_money: float

    class Config:
        orm_mode = True

class MatchCreate(MatchBase):
    pass


class AccountCreate(AccountBase):
    password: str = Field(..., min_length=8, max_length=24, description="user password")


class Account(AccountBase):
    class Config:
        orm_mode = True


class TokenSchema(BaseModel):
    access_token: str
    refresh_token: str


class TokenPayload(BaseModel):
    sub: str = None
    exp: int = None


class SystemAccount(Account):
    password: str


class Match(MatchBase):
    id: int

    class Config:
        orm_mode = True
