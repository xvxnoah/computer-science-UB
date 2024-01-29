// ModifyReview.js
import React, { useState } from 'react';
import { Button, Modal, Form } from 'react-bootstrap';
import { useAuth } from "./AuthContext";
import {
  StarFill,
  Star
} from "react-bootstrap-icons";

const ModifyReview = ({ show, reviewId, recipeId, onHide, reloadReviews, funct, reviewInfo }) => {
  const [newComment, setNewComment] = useState(reviewInfo.comment);
  const [newRating, setNewRating] = useState(reviewInfo.rating);
  const [newImage, setNewImage] = useState(reviewInfo.file); 
  const [characterCount, setCharacterCount] = useState(0);
  const { token } = useAuth();

  const handleUpdateReview = async () => {
    const bodyData = {
      comment: newComment,
      rating: newRating,
    };
    if (newImage) {
      bodyData.file = newImage;
    }
    console.log(">>>>NewImage: ", newImage)
    
    try {
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/review/${recipeId}/${reviewId}`,
        {
          method: 'PUT',
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: JSON.stringify({ comment: newComment, rating: newRating }),  
          file: newImage      
        }
      );

      const data = await response.json();
      if (response.ok) {
        console.log('Review actualizada:', data);
        reloadReviews();
      } else {
        console.error('Error al actualizar la revisión:', data);
      }
    } catch (error) {
      console.error('Error en la solicitud de actualización de la revisión:', error);
    }

    onHide();
  };

  const handleDeleteReview = async () => {
    try {
      const response = await fetch(
        `${process.env.REACT_APP_API_URL}/review/${recipeId}/${reviewId}`,
        {
          method: 'DELETE',
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      const data = await response.json();
      if (response.ok) {
        console.log('Review eliminada:', data);
        reloadReviews();
      } else {
        console.error('Error al eliminar la revisión:', data);
      }
    } catch (error) {
      console.error('Error en la solicitud de eliminación de la revisión:', error);
    }

    onHide();
  };

  const renderStars = (amount) => {
    let stars = [];
    for (let i = 1; i <= 5; i++) {
      stars.push(
        <span
          key={i}
          className={"difficulty-star "
            .concat(i <= amount ? "active" : "inactive")
            .concat(" ms-2 fs-4")}
          role="button"
          onClick={() => setNewRating(i)}
        >
          {i <= amount ? <StarFill /> : <Star />}
        </span>
      );
    }
    return stars;
  };

  const handleReviewChange = (e) => {
    const inputReview = e.target.value;
    setNewComment(inputReview)
    setCharacterCount(inputReview.length);
  };

  const handleConfirmDelete = () => {
    handleDeleteReview();
  };

  return (
    <Modal show={show} onHide={onHide}>
      <Modal.Header closeButton className="fw-bold bg-normal">
        <Modal.Title>{funct === 'Edit' ? 'Modify' : 'Delete'} review</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-lightest">
        {funct === 'Edit' ? (
          <Form>
            <Form.Group className="mb-3 fw-bold">
              <Form.Label>New Review</Form.Label>
              <Form.Control
                as="textarea"
                rows={3}
                placeholder="Write your new review here"
                value={newComment}
                onChange={handleReviewChange}
                style={{ borderColor: characterCount > 120 ? 'red' : null }}
              />
              {characterCount > 120 && (
              <div className="text-danger">You exceeded 120 characters.</div>
            )}
            <div className="mt-2 text-muted">Num characters: {characterCount}</div>
            </Form.Group>
            <Form.Group className="mb-3 fw-bold">
              <Form.Label>New Rating</Form.Label>
              <div>{renderStars(newRating)}</div>
            </Form.Group>
          </Form>
        ) : (
          <p className='fw-bold fs-4'>Are you sure delete review?</p>
        )}
      </Modal.Body>
      <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
        {funct === 'Edit' ? (
          <Button className='bg-danger fw-bold border-secondary text-white' variant="primary" onClick={handleUpdateReview} disabled={characterCount > 120}>
            Update
          </Button>
        ) : (
          <>
            <Button variant="danger" onClick={handleConfirmDelete}>
              Accept
            </Button>
            <Button variant="secondary" onClick={onHide}>
              Cancel
            </Button>
          </>
        )}
      </Modal.Footer>
    </Modal>
  );
};

export default ModifyReview;
