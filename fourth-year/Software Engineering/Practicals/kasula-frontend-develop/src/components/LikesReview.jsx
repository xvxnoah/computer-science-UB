// LikesReview.js
import React, { useState } from "react";
import {Row, Col } from "react-bootstrap";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faHeart as heartSolid } from '@fortawesome/free-solid-svg-icons'; // Icono sólido
import { faHeart as heartRegular } from '@fortawesome/free-regular-svg-icons'; // Icono regular
import { useAuth } from "./AuthContext";

function LikesReview({ reviewUsername, recipeId, reviewId, initialLikes, likedBy, reloadReviews }) {
  const [likes, setLikes] = useState(initialLikes);
  const [hasLiked, setHasLiked] = useState(false);
  const currentUserUsername = localStorage.getItem('currentUser');
  const [hasLikedByUser, setHasLikedByUser] = useState(likedBy.includes(currentUserUsername));
  const { token } = useAuth();
  const isLogged = window.localStorage.getItem("logged");
  const isOwnerReview = currentUserUsername === reviewUsername;

  const handleLikeClick = async () => {
    if(isLogged === 'true' && !isOwnerReview){
        if (hasLiked || hasLikedByUser) {
          likes > 0 ? setLikes(likes - 1) : setLikes(0);  
          setHasLiked(false);  
          setHasLikedByUser(false);    
          try {
            const response = await fetch(
              `${process.env.REACT_APP_API_URL}/review/unlike/${recipeId}/${reviewId}`,
              {
                method: "PATCH",
                headers: {
                  Authorization: `Bearer ${token}`,
              },
              }
            );
      
            const data = await response.json();
            if (!response.ok) {
              console.error("Error al enviar el dislike:", data);
            }
          } catch (error) {
            console.error("Error en la solicitud de dislike:", error);
          }
        }else{
          setLikes(likes + 1);
          setHasLiked(true);
          setHasLikedByUser(true);    
        try {
          const response = await fetch(
            `${process.env.REACT_APP_API_URL}/review/like/${recipeId}/${reviewId}`,
            {
              method: "PATCH",
              headers: {
                Authorization: `Bearer ${token}`,
            },
            }
          );

          const data = await response.json();
          if (!response.ok) {
            console.error("Error al enviar el like:", data);
          }
        } catch (error) {
          console.error("Error en la solicitud de like:", error);
        }
      }
      reloadReviews()}
  };

  const cursorStyle = isLogged === 'true' && !isOwnerReview ? { cursor: "pointer" } : { cursor: "not-allowed" };

  const iconoLike = hasLikedByUser ? heartSolid : heartRegular;

  return (
    <Row>
      <Col sm={3}>
        <FontAwesomeIcon
          icon={iconoLike}
          onClick={handleLikeClick}
          style={{ color: 'red', ...cursorStyle }}
        />
      </Col>
      <Col sm={8}>
        <span className="">{likes} likes</span>
      </Col>
      <Col sm={1}></Col>
    </Row>  
  );
}

export default LikesReview;
