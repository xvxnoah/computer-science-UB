from fastapi import Depends, FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from fastapi import Depends, FastAPI, HTTPException
from fastapi.encoders import jsonable_encoder
from fastapi.security import OAuth2PasswordRequestForm
from dependencies import get_current_user, get_current_user
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session
from utils import verify_password, create_access_token, create_refresh_token, get_hashed_password

import repository, models, schemas
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)  # Creem la base de dades amb els models que hem definit a SQLAlchemy

app = FastAPI()

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

# Static files
app.mount("/static", StaticFiles(directory="frontend/dist/static"), name="static")

# Templates
templates = Jinja2Templates(directory="frontend/dist")


@app.get("/")
async def serve_index(request: Request):
    return templates.TemplateResponse("index.html", {"request": request})


# Dependency to get a DB session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


@app.get("/")
def read_root():
    return {"message": "Hello World"}


"-------"
" TEAMS "
"-------"


@app.get("/teams/", response_model=list[schemas.Team])
def read_teams(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return repository.get_teams(db, skip=skip, limit=limit)


@app.post("/teams/", response_model=schemas.Team)
def create_team(team: schemas.TeamCreate, db: Session = Depends(get_db)):
    db_team = repository.get_team_by_name(db, name=team.name)
    if db_team:
        raise HTTPException(status_code=400, detail="Team already Exists, Use put for updating")
    else:
        return repository.create_team(db=db, team=team)


@app.get("/team/{team_name}", response_model=schemas.Team)
def read_team(team_name: str, db: Session = Depends(get_db)):
    team = repository.get_team_by_name(db, name=team_name)
    if not team:
        raise HTTPException(status_code=404, detail="Team not found")
    return team


# Update team
@app.put("/teams/{team_name}", response_model=schemas.Team)
def update_team(team_name: str, team_update: schemas.TeamUpdate, db: Session = Depends(get_db)):
    updated_team = repository.update_team(db, team_name, team_update)
    if updated_team:
        return updated_team
    raise HTTPException(status_code=404, detail="Team not found")


# Delete team
@app.delete("/teams/{team_name}", response_model=schemas.Team)
def delete_team(team_name: str, db: Session = Depends(get_db)):
    deleted_team = repository.delete_team(db, team_name)
    if deleted_team:
        return deleted_team
    raise HTTPException(status_code=404, detail="Team not found")


"--------------"
" COMPETITIONS "
"--------------"


@app.get("/competitions/", response_model=list[schemas.Competition])
def read_competitions(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return repository.get_competitions(db, skip=skip, limit=limit)


@app.post("/competitions/", response_model=schemas.Competition)
def create_competition(competition: schemas.CompetitionCreate, db: Session = Depends(get_db)):
    db_competition = repository.get_competition_by_name(db, name=competition.name)
    if db_competition:
        raise HTTPException(status_code=400, detail="Competition already Exists, Use put for updating")
    else:
        return repository.create_competition(db=db, competition=competition)


@app.get("/competitions/{competition_name}", response_model=schemas.Competition)
def read_competition(competition_name: str, db: Session = Depends(get_db)):
    competition = repository.get_competition_by_name(db, name=competition_name)
    if not competition:
        raise HTTPException(status_code=404, detail="Competition not found")
    return competition


# Update competition
@app.put("/competitions/{competition_id}", response_model=schemas.Competition)
def update_competition(competition_id: int, competition_update: schemas.Competition, db: Session = Depends(get_db)):
    updated_competition = repository.update_competition(db, competition_id, competition_update)
    if updated_competition:
        return updated_competition
    raise HTTPException(status_code=404, detail="Competition not found")


# Delete competition by id
@app.delete("/competitions/{competition_id}", response_model=schemas.Competition)
def delete_competition(competition_id: int, db: Session = Depends(get_db)):
    deleted_competition = repository.delete_competition_by_id(db, competition_id)
    if deleted_competition:
        return deleted_competition
    raise HTTPException(status_code=404, detail="Competition not found")


# Delete competition by name
@app.delete("/competitions/{competition_name}", response_model=schemas.Competition)
def delete_competition(competition_name: str, db: Session = Depends(get_db)):
    deleted_competition = repository.delete_competition_by_name(db, competition_name)
    if deleted_competition:
        return deleted_competition
    raise HTTPException(status_code=404, detail="Competition not found")


"---------"
" MATCHES "
"---------"


@app.get("/matches/", response_model=list[schemas.Match])
def read_matches(skip: int = 0, limit: int = 10, db: Session = Depends(get_db)):
    return repository.get_matches(db, skip=skip, limit=limit)


@app.post("/matches/", response_model=schemas.Match)
def create_match(match: schemas.MatchCreate, db: Session = Depends(get_db)):
    db_local_team = match.local
    db_visitor_team = match.visitor
    db_competition = match.competition

    if repository.match_already_exists(db, local_id=match.local.id, visitor_id=match.visitor.id,
                                       competition_id=match.competition.id, match_date=match.date):
        raise HTTPException(status_code=400, detail="Match already exists")
    else:
        return repository.create_match(db=db, match=match)


@app.get("/matches/{match_id}", response_model=schemas.Match)
def read_match(match_id: int, db: Session = Depends(get_db)):
    match = repository.get_match(db, match_id=match_id)
    if not match:
        raise HTTPException(status_code=404, detail="Match not found")
    return match


# Update match
@app.put("/matches/{match_id}", response_model=schemas.Match)
def update_match(match_update: schemas.Match, db: Session = Depends(get_db)):
    updated_match = repository.update_match(db, match_update)
    if updated_match:
        return updated_match
    raise HTTPException(status_code=404, detail="Match not found")


# Delete match
@app.delete("/matches/{match_id}")
def delete_match(match_id: int, db: Session = Depends(get_db)):
    deleted_match = repository.delete_match(db, match_id)
    if deleted_match:
        return jsonable_encoder(deleted_match)
    raise HTTPException(status_code=404, detail="Match not found")


" ADICIONAL "


# GET /teams/{team_name}/matches
@app.get("/teams/{team_name}/matches")
def get_team_matches(team_name: str, db: Session = Depends(get_db)):
    matches = repository.get_team_matches(db, team_name)
    return {"matches": matches}


# GET /teams/{team_name}/competitions
@app.get("/teams/{team_name}/competitions")
def get_team_competitions(team_name: str, db: Session = Depends(get_db)):
    competitions = repository.get_team_competitions(db, team_name)
    return {"competitions": competitions}


# GET /competitions/{competition_name}/matches
@app.get("/competitions/{competition_name}/matches")
def get_competition_matches(competition_name: str, db: Session = Depends(get_db)):
    matches = repository.get_competition_matches(db, competition_name)
    return {"matches": matches}


# GET /competitions/{competition_name}/teams
@app.get("/competitions/{competition_name}/teams")
def get_competition_teams(competition_name: str, db: Session = Depends(get_db)):
    teams = repository.get_competition_teams(db, competition_name)
    return {"teams": teams}


# GET /matches/{match_id}/teams
@app.get("/matches/{match_id}/teams")
def get_match_teams(match_id: int, db: Session = Depends(get_db)):
    local, visitor = repository.get_match_teams(db, match_id)
    return {"local": local, "visitor": visitor}


# GET /matches/{match_id}/competition
@app.get("/matches/{match_id}/competition")
def get_match_competition(match_id: int, db: Session = Depends(get_db)):
    competition = repository.get_match_competition(db, match_id)
    return {"competition": competition}


"--------------------"
"ACCOUNTS AND ORDERS"
"--------------------"


@app.get('/account', summary='Get details of currently logged in user', response_model=schemas.AccountResponse)
async def get_me(username: str = None, user: schemas.SystemAccount = Depends(get_current_user)):
    return user

@app.delete('/account', summary='Delete currently logged in user', response_model=schemas.AccountResponse)
async def get_me(user: schemas.SystemAccount = Depends(get_current_user)):
    return {"detail": "Account deleted"}

@app.put('/account', response_model=schemas.Account)
def update_account(account_data: schemas.AccountBase, db: Session = Depends(get_db), user: schemas.SystemAccount = Depends(get_current_user)):
    updated_account_data = schemas.AccountBase(
        username=user.username,
        is_admin=user.is_admin,
        available_money=account_data.available_money,
        orders=account_data.orders
    )
    return repository.update_account(db=db, account=updated_account_data)

@app.post('/account', summary="Create new user", response_model=schemas.AccountResponse)
def create_account(account: schemas.AccountCreate, db: Session = Depends(get_db)):
    db_account = repository.get_account_by_username(db, username=account.username)
    if db_account:
        raise HTTPException(status_code=400, detail="Account already Exists, Use put for updating")
    else:
        account_data = schemas.AccountBase(
            username=account.username,
            is_admin=account.is_admin,
            available_money=account.available_money,
            orders=account.orders
        )
        return repository.create_account(db=db, account=account_data, password=account.password)

@app.get('/account/{username}', summary='Get details of the user', response_model=schemas.AccountResponse)
async def get_user(username: str, db: Session = Depends(get_db), admin: schemas.SystemAccount = Depends(get_current_user)):
    user = repository.get_account_by_username(db=db, username=username)
    if user is None:
        raise HTTPException(status_code=404, detail="Account not found")

    return user

@app.put('/account/{username}', summary='Update the user', response_model=schemas.AccountResponse)
async def update_user(username: str, account_data: schemas.AccountUpdate, db: Session = Depends(get_db), admin: schemas.SystemAccount = Depends(get_current_user)): 
    updated_user = repository.update_account(db=db, account=account_data)
    if updated_user is None:
        raise HTTPException(status_code=404, detail="Account not found")
    return updated_user

@app.delete('/account/{username}', summary='Delete the user', response_model=schemas.AccountResponse)
def delete_user(username: str, db: Session = Depends(get_db), admin: schemas.SystemAccount = Depends(get_current_user)):
    deleted_user = repository.delete_account(db=db, username=username)
    if deleted_user is None:
        raise HTTPException(status_code=404, detail="Account not found")
    return {"detail": "Account deleted"}


@app.get('/accounts', response_model=list[schemas.Account])
def get_all_accounts(db: Session = Depends(get_db)):
    return repository.get_all_accounts(db)


@app.get('/orders', summary='Get details of orders of currently logged in user', response_model=schemas.AccountResponse)
async def get_me( db: Session = Depends(get_db),user: schemas.SystemAccount = Depends(get_current_user)):
    return repository.get_orders_by_user(db=db, username=user.username)

"ADMIN OPTION"
@app.get("/orders/{username}", response_model=list[schemas.OrderBase])
def get_orders(username: str, db: Session = Depends(get_db), admin: schemas.SystemAccount = Depends(get_current_user)):
    db_account = repository.get_account_by_username(db, username=username)
    if not db_account:
        raise HTTPException(status_code=404, detail="Account not found")
    else:
        return repository.get_orders_by_user(db=db, username=username)

@app.post('/orders', summary='Create orders of currently logged in user', response_model=schemas.AccountResponse)
async def get_me( order: schemas.OrderCreate, db: Session = Depends(get_db),user: schemas.SystemAccount = Depends(get_current_user)):
    return repository.create_order(db=db, username=user.username, order=order)

"ADMIN OPTION"
@app.post('/orders/{username}', response_model=schemas.Order)
def create_order(username: str, order: schemas.OrderCreate, db: Session = Depends(get_db), admin: schemas.SystemAccount = Depends(get_current_user)):
    db_account = repository.get_account_by_username(db, username=username)
    if not db_account:
        raise HTTPException(status_code=404, detail="Account not found")

    db_match = db.query(models.Match).filter(models.Match.id == order.match_id).first()

    # 1. Check if the user has enough money to buy the ticket
    if db_account.available_money < db_match.price * order.tickets_bought:
        raise HTTPException(status_code=400, detail="Not enough money to buy the tickets.")

    # 2. Check if there are enough tickets available
    if db_match.total_available_tickets < order.tickets_bought:
        raise HTTPException(status_code=400, detail="Not enough tickets available.")

    return repository.create_order(db=db, username=username, order=order)

@app.post('/login', summary="Create access and refresh tokens for user", response_model=schemas.TokenSchema)
async def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    username = form_data.username
    password = form_data.password

    # Get user from the database
    user = repository.get_account_by_username(db, username=username)

    # If user does not exist, raise an exception
    if not user:
        raise HTTPException(status_code=404, detail="User not found")

    # Verify the password
    if not verify_password(password, user.password):
        raise HTTPException(status_code=400, detail="Incorrect password")

    # Create access and refresh tokens
    access_token = create_access_token(user.username)
    refresh_token = create_refresh_token(user.username)

    # Return the tokens
    return {
        "access_token": access_token,
        "refresh_token": refresh_token
    }
