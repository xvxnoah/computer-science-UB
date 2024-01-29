from typing import Union, Any
from datetime import datetime
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session
from jose import jwt
from pydantic import ValidationError
from functools import lru_cache
import database
import utils, repository
from schemas import TokenPayload, SystemAccount
import logging
from fastapi import Request

@lru_cache()
def get_settings():
    return utils.Settings()


reuseable_oauth = OAuth2PasswordBearer(
    tokenUrl="/login",
    scheme_name="JWT"
)


def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()


async def get_current_user(
        request: Request,
        token: str = Depends(reuseable_oauth),
        settings: utils.Settings = Depends(get_settings),
        db: Session = Depends(get_db)
) -> SystemAccount:
    username = request.query_params.get("username")
    try:
        payload = jwt.decode(
            token, settings.jwt_secret_key, algorithms=[settings.algorithm]
        )
        token_data = TokenPayload(**payload)

        if datetime.fromtimestamp(token_data.exp) < datetime.now():
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token expired",
                headers={"WWW-Authenticate": "Bearer"},
            )
    except (jwt.JWTError, ValidationError):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Could not validate credentials",
            headers={"WWW-Authenticate": "Bearer"},
        )
    username2: str = token_data.sub
    db_account = repository.get_account_by_username(db, username=username2)
    if db_account is None:
        raise HTTPException(status_code=404, detail="Account not found")
    if db_account.is_admin == 0 and username != username2:
        raise HTTPException(
            status_code=status.HTTP_403_,
            detail="Admin access required",
            headers={"WWW-Authenticate": "Bearer"},
        )
    return SystemAccount(**db_account.__dict__)
