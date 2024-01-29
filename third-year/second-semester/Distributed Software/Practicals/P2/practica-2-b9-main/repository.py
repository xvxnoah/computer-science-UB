from datetime import datetime

from fastapi import HTTPException
from sqlalchemy.exc import SQLAlchemyError, IntegrityError
from sqlalchemy.orm import Session, joinedload
import models, schemas
from sqlalchemy.orm.exc import NoResultFound

from utils import get_hashed_password


def get_team(db: Session, team_id: int):
    return db.query(models.Team).filter(models.Team.id == team_id).first()


def get_team_by_name(db: Session, name: str):
    return db.query(models.Team).filter(models.Team.name == name).first()


def get_team_by_id(db: Session, team_id: int):
    team = db.query(models.Team).filter(models.Team.id == team_id).first()
    return team


def get_teams(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Team).offset(skip).limit(limit).all()


def create_team(db: Session, team: schemas.TeamCreate):
    db_team = models.Team(name=team.name, country=team.country, description=team.description)
    try:
        db.add(db_team)
        db.commit()
        db.refresh(db_team)
        return db_team
    except:
        db.rollback()
        return {"message": "An error occurred inserting the teams."}, 500


# Update team
def update_team(db: Session, team_name: str, team_update: schemas.Team):
    db_team = db.query(models.Team).filter(models.Team.name == team_name).first()
    if db_team:
        for key, value in team_update.dict().items():
            if value:
                setattr(db_team, key, value)
        try:
            db.commit()
            db.refresh(db_team)
        except:
            db.rollback()
            return {"message": "An error occurred updating the team."}, 500
    return db_team


# Delete team
def delete_team(db: Session, team_name: str):
    db_team = db.query(models.Team).filter(models.Team.name == team_name).first()
    if db_team:
        try:
            db.delete(db_team)
            db.commit()
        except:
            db.rollback()
            return {"message": "An error occurred deleting the team."}, 500
    return db_team


def get_competition(db: Session, competition_id: int):
    return db.query(models.Competition).options(joinedload(models.Competition.teams),
                                                joinedload(models.Competition.matches)).filter(
        models.Competition.id == competition_id).first()


def get_competition_by_name(db: Session, name: str):
    return db.query(models.Competition).filter(models.Competition.name == name).first()


def get_competition_by_id(db: Session, competition_id: int):
    competition = db.query(models.Competition).filter(models.Competition.id == competition_id).first()
    return competition


def get_competitions(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Competition).options(joinedload(models.Competition.teams),
                                                joinedload(models.Competition.matches)).offset(skip).limit(limit).all()


def create_competition(db: Session, competition: schemas.CompetitionCreate):
    db_competition = models.Competition(name=competition.name, category=competition.category.value,
                                        sport=competition.sport.value)

    # Associate teams with the competition
    for team_obj in competition.teams:
        team_dict = team_obj.dict()
        team_id = team_dict['id']
        team = db.query(models.Team).filter(models.Team.id == team_id).one()
        db_competition.teams.append(team)

    try:
        db.add(db_competition)
        db.commit()
        db.refresh(db_competition)
        return db_competition

    except IntegrityError:
        db.rollback()
        raise HTTPException(status_code=400,
                            detail="An error occurred inserting the competition. Check for duplicate entries or invalid data.")
    except Exception as e:
        db.rollback()
        raise HTTPException(status_code=500, detail="An unexpected error occurred.")


# Update competition
def update_competition(db: Session, competition_id: int, competition_update: schemas.Competition):
    db_competition = db.query(models.Competition).filter(models.Competition.id == competition_id).first()

    if db_competition:
        for key, value in competition_update.dict().items():
            if value:
                if key in ["category", "sport"]:
                    value = value.value  # Convert the enumeration value to its string representation
                setattr(db_competition, key, value)

        try:
            db.commit()
            db.refresh(db_competition)
        except:
            db.rollback()
            return {"message": "An error occurred updating the competition."}, 500

    return db_competition


# Delete competition
def delete_competition_by_id(db: Session, competition_id: int):
    db_competition = db.query(models.Competition).filter(models.Competition.id == competition_id).first()
    if db_competition:
        try:
            db.delete(db_competition)
            db.commit()
        except:
            db.rollback()
            return {"message": "An error occurred deleting the competition."}, 500
    return db_competition


def delete_competition_by_name(db: Session, competition_name: str):
    db_competition = db.query(models.Competition).filter(models.Competition.name == competition_name).first()
    if db_competition:
        try:
            db.delete(db_competition)
            db.commit()
        except:
            db.rollback()
            return {"message": "An error occurred deleting the competition."}, 500
    return db_competition


def match_already_exists(db: Session, local_id: int, visitor_id: int, competition_id: int, match_date: datetime):
    match = db.query(models.Match).filter(
        (models.Match.local_id == local_id) &
        (models.Match.visitor_id == visitor_id) &
        (models.Match.competition_id == competition_id) &
        (models.Match.date == match_date)
    ).first()
    if match:
        return True
    else:
        return False


def get_match(db: Session, match_id: int):
    return db.query(models.Match).options(joinedload(models.Match.local), joinedload(models.Match.visitor)).filter(
        models.Match.id == match_id).first()


def get_matches(db: Session, skip: int = 0, limit: int = 100):
    return db.query(models.Match).options(joinedload(models.Match.local), joinedload(models.Match.visitor)).offset(
        skip).limit(limit).all()


def create_match(db: Session, match: schemas.MatchCreate):
    db_match = models.Match(
        date=match.date,
        price=match.price,
        local_id=match.local.id,
        visitor_id=match.visitor.id,
        competition_id=match.competition.id,
        total_available_tickets=match.total_available_tickets
    )

    try:
        db.add(db_match)
        db.commit()
        db.refresh(db_match)
        return db_match
    except:
        db.rollback()
        return {"message": "An error occurred inserting the match."}, 500


# Update match
def update_match(db: Session, match_update: schemas.Match):
    db_match = db.query(models.Match).filter(models.Match.id == match_update.id).first()
    if db_match:
        for key, value in match_update.dict().items():
            if value:
                if key in ["price", "date"]:
                    setattr(db_match, key, value)

        try:
            db.commit()
            db.refresh(db_match)
        except:
            db.rollback()
            return {"message": "An error occurred updating the match."}, 500
    return db_match


# Delete match
def delete_match(db: Session, match_id: int):
    db_match = (
        db.query(models.Match)
        .options(joinedload(models.Match.local), joinedload(models.Match.visitor))
        .filter(models.Match.id == match_id)
        .first()
    )
    if db_match:
        try:
            db.delete(db_match)
            db.commit()
        except:
            db.rollback()
            return {"message": "An error occurred deleting the match."}, 500
    return db_match


def delete_match_by_id(db: Session, match_id):
    with Session() as session:
        match = session.query(models.Match).filter(models.Match.id == match_id).one()
        _ = match.local  # Acceder al atributo 'local' para cargarlo antes de eliminar
        session.delete(match)
        session.commit()


def get_team_matches(db: Session, team_name: str):
    try:
        team = db.query(models.Team).filter(models.Team.name == team_name).one()
        matches = team.matches
    except NoResultFound:
        # Puedes devolver una lista vacía, None o manejarlo de alguna otra manera.
        matches = []

    return matches


def get_team_competitions(db: Session, team_name: str):
    team = db.query(models.Team).filter(models.Team.name == team_name).one()
    competitions = db.query(models.Competition).join(models.Competition.teams).filter(models.Team.id == team.id).all()
    return competitions


def get_competition_matches(db: Session, competition_name: str):
    competition = db.query(models.Competition).filter(models.Competition.name == competition_name).one()
    matches = db.query(models.Match).filter(models.Match.competition_id == competition.id).all()
    return matches


def get_competition_teams(db: Session, competition_name: str):
    competition = db.query(models.Competition).filter(models.Competition.name == competition_name).one()
    teams = competition.teams
    return teams


def get_match_teams(db: Session, match_id: int):
    match = db.query(models.Match).filter(models.Match.id == match_id).one()
    local = match.local
    visitor = match.visitor
    return local, visitor


def get_match_competition(db: Session, match_id: int):
    match = db.query(models.Match).filter(models.Match.id == match_id).one()
    competition = match.competition
    return competition


def get_account_by_username(db: Session, username: str):
    return db.query(models.Account).filter(models.Account.username == username).first()


def create_account(db: Session, account: schemas.AccountBase, password: str):
    hashed_password = get_hashed_password(password)

    db_account = models.Account(
        username=account.username,
        available_money=account.available_money,
        is_admin=account.is_admin
    )

    db_account.password = hashed_password  # set the hashed password

    try:
        db.add(db_account)
        db.commit()
        db.refresh(db_account)
        return db_account
    except:
        db.rollback()
        return {"message": "An error occurred inserting the account."}, 500


def get_orders_by_user(db: Session, username: str):
    db_account = get_account_by_username(db, username)
    if db_account is None:
        return []
    else:
        orders = []
        for order in db_account.orders:
            # Convert SQLAlchemy model instance to dict
            order_dict = order.__dict__
            # Remove unwanted keys
            order_dict.pop('_sa_instance_state', None)
            orders.append(order_dict)
        return orders


def get_all_orders(db: Session):
    return db.query(models.Order).all()


def create_order(db: Session, username: str, order: schemas.OrderCreate):
    db_account = get_account_by_username(db, username)
    db_match = db.query(models.Match).filter(models.Match.id == order.match_id).first()

    # Create the Order without manually setting username
    db_order = models.Order(match_id=order.match_id, tickets_bought=order.tickets_bought)

    # 3. Update tickets available in Match (- tickets purchased)
    db_match.total_available_tickets -= order.tickets_bought

    # 4. Update user's money after buying tickets (-price * tickets bought)
    db_account.available_money -= db_match.price * order.tickets_bought

    # 5. Add the order to the user relation (this will automatically set Order's username)
    db_account.orders.append(db_order)

    try:
        # 6. Save the changes made to order, match and user in the DB
        db.commit()
        db.refresh(db_order)
        return db_order
    except SQLAlchemyError:
        db.rollback()
        return {"message": "An error occurred creating the order."}, 500


def get_all_accounts(db: Session):
    return db.query(models.Account).all()


def delete_account(db: Session, username: str):
    db_account = db.query(models.Account).filter(models.Account.username == username).first()

    if db_account:
        db.delete(db_account)
        db.commit()
        return db_account
    else:
        return None

def update_account(db: Session, account: schemas.AccountBase):
    db_account = db.query(models.Account).filter(models.Account.username == account.username).first()
    if db_account is None:
        return None

    if account.available_money is not None:
        db_account.available_money = account.available_money
    if account.orders is not None:
        db_account.orders = account.orders
    db.refresh(db_account)
    db.commit()
    return db_account

