import React, { useState, useEffect } from 'react';
import { Modal, Button, Form, Alert } from 'react-bootstrap';
import { useAuth } from "./AuthContext";
import {
  StarFill,
  Star
} from "react-bootstrap-icons";
const PostReview = ({ id, show, onHide, reloadReviews }) => {
  const [username, setUsername] = useState('');
  const [review, setReview] = useState('');
  const [difficulty, setDifficulty] = useState(1);
  const [data2, setData2] = useState(null);
  const [image, setImage] = useState(null);
  const { token } = useAuth();
  const [error, setError] = useState(null);
  const [showErrorModal, setShowErrorModal] = useState(false);
  const [characterCount, setCharacterCount] = useState(0);

  useEffect(() => {
    fetch(process.env.REACT_APP_API_URL + "/user/me", {
        method: "GET",
        headers: {
        Authorization: `Bearer ${token}`,
        },
    })
        .then((response) => response.json())
        .then((data) => {
          setData2(data);
          setUsername(data?.username);
        })
        .catch((error) => console.error("Error:", error));
  }, [id])

  const handleFileChange = (event) => {
    const selectedImage= event.target.files[0];
    setImage(selectedImage);
  };

  const handleReviewChange = (e) => {
    const inputReview = e.target.value;
    const remainingCharacters = 120 - inputReview.length;
    setReview(inputReview);
    setCharacterCount(remainingCharacters);
  };

  const handlePostReview = async () => {
    const reviewData = {
      username: username,
      comment: review,
      rating: difficulty,
    };

    const formData = new FormData();
    formData.append("review", JSON.stringify(reviewData));

    if (image) {
      formData.append("file", image);
    }
     try {
       const response = await fetch(process.env.REACT_APP_API_URL + `/review/${id}`, {
         method: "POST",
         headers: {
           Authorization: `Bearer ${token}`,
         },
         body: formData,
       });
       const data = await response.json();
       if (response.ok) {
         console.log(">>>Post hecho: ", data)
       } else{
        setError("You have already reviewed this recipe!")
        // setError(data.detail);
        setShowErrorModal(true);
      }
     } catch (error) {
       setError(error);
       setShowErrorModal(true);
     }
    setReview('');
    setImage(null);

    onHide();
    reloadReviews();
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
          onClick={() => setDifficulty(i)}
        >
          {i <= amount ? <StarFill /> : <Star />}
        </span>
      );
    }
    return stars;
  };


  return (<>
    <Modal show={show} onHide={onHide}>
      <Modal.Header closeButton className="fw-bold bg-normal"> 
        <Modal.Title>Post a review</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-lightest">
        <Form>
          <Form.Group className="mb-3 fw-bold">
            <Form.Label>Review</Form.Label>
            <Form.Control
              as="textarea"
              rows={3}
              placeholder="Write your review here"
              value={review}
              onChange={handleReviewChange}
              style={{ borderColor: characterCount < 0 ? 'red' : null }}
            />

            {characterCount < 0 && (
              <div className="text-danger">You exceeded the character limit.</div>
            )}

            <div className="mt-2 text-muted">Characters remaining: {characterCount}</div>
          </Form.Group>
          <Form.Group className="mb-3 fw-bold">
            <Form.Label>Rating</Form.Label>
            <div>{renderStars(difficulty)}</div>
          </Form.Group>

          <Form.Group className="mb-3 fw-bold">
            <Form.Label>Select Image</Form.Label>
            <Form.Control type="file" onChange={handleFileChange} />
          </Form.Group>
        </Form>
      </Modal.Body>
      <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
        <Button variant="secondary" onClick={onHide}>
          Close
        </Button>
        <Button
        className='bg-danger fw-bold border-secondary text-white'
          variant="primary"
          onClick={handlePostReview}
          disabled={characterCount < 0}
        >
          Post review
        </Button>
      </Modal.Footer>
    </Modal>
     <Modal show={showErrorModal} onHide={() => setShowErrorModal(false)}>
     <Modal.Header closeButton className="bg-normal">
       <Modal.Title className='fw-bold'>Not allowed</Modal.Title>
     </Modal.Header>
     <Modal.Body className="bg-lightest">
       <Alert variant="danger" className='fw-bold'>
         {error && <p>{error}</p>}
       </Alert>
     </Modal.Body>
     <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
       <Button variant="secondary" onClick={() => setShowErrorModal(false)}>
         Close
       </Button>
     </Modal.Footer>
   </Modal>
   </>
  );
};

export default PostReview;
