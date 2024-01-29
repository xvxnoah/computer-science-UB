import React, { useState, useEffect } from "react";
import { Container, Row, Col, Button, Image } from "react-bootstrap";
import PostReview from "./PostReview";
import { StarFill, PatchCheck, PencilSquare, Trash } from 'react-bootstrap-icons';
import { useNavigate } from "react-router-dom";
import LikesReview from "./LikesReview";
import ImageModal from "./ImageModal";
import ModifyReview from "./ModifyReview";

function Reviews(props) {
  const { id, reloadReviews, owner } = props;
  const [reviews, setReviews] = useState(null);
  const [showModal, setShowModal] = useState(false);
  const [showModalImage, setShowModalImage] = useState(false);
  const [showModalReview, setShowModalReview] = useState(false);
  const [selectedImage, setSelectedImage] = useState(null); 
  const [selectedReview, setSelectedReview] = useState(null);
  const [selectedFunct, setSelectedFunct] = useState(null);
  const isLogged = window.localStorage.getItem("logged");
  const currentUser = localStorage.getItem('currentUser');
  const navigate = useNavigate();


  useEffect(() => {
    fetch(`${process.env.REACT_APP_API_URL}/review/${id}`)
      .then((response) => response.json())
      .then((data) => {
        setReviews(data);
      })
      .catch((error) => console.error("Error al obtener receta:", error));
  }, [id, reloadReviews]); 

  const handleOpenModalImage = (image) => {
    setSelectedImage(image);
    setShowModalImage(true);
  };

  const handleCloseModalImage = () => {
    setSelectedImage(null);
    setShowModalImage(false);
  };

  const handleOpenModal = () => {
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
  };

  const handleOpenModalReview = (review, funct) => {
    setSelectedReview(review);
    setShowModalReview(true);
    setSelectedFunct(funct);

  };

  const handleCloseModalReview = () => {
    setSelectedReview(null);
    setShowModalReview(false);
    setSelectedFunct(null);
  };

  const handleNavigate = (userId) => {
    navigate(`/UserProfile/${userId}`);
  };

  return (
    <Container className="flex-column justify-content-between align-items-center">
      {isLogged === 'true' ? 
        <Row className="mt-2">
          {reviews && reviews.length > 0 && owner !== currentUser ? (<>
          <Button className="mx-auto fs-6 bg-danger fw-bold border-secondary text-white" onClick={handleOpenModal}>
            Post a review
          </Button>
          <PostReview
            id={id}
            show={showModal}
            onHide={handleCloseModal}
            reloadReviews={reloadReviews}
          /> 
          </>) : null}
        </Row>
      : null}
      <Col sm={12} className="mt-4 mx-auto">
        <Container>
          <ul className="list-unstyled">
            {reviews && reviews.length > 0 ? (
              reviews.map((review, index) => (
                <li key={index} className="mb-3 p-2 fs-6 bg-light box-shadow">
                  {review.image ? 
                  <Row>
                    <Col sm={12}>
                    <div className="fw-bold" style={{ cursor: 'pointer' }} onClick={() => handleNavigate(review.username)}>
                        {review.username}:{" "}
                      </div>
                    </Col>
                    <Col sm={12}>{review.comment}</Col>
                    <Col sm={5} className="mt-2">
                      <Image
                        src={review.image}
                        alt={review.user}
                        onClick={() => handleOpenModalImage(review.image)}
                        style={{
                          width: "112px",
                          height: "96px",
                          borderRadius: "20%",
                          cursor: "pointer"
                        }}
                      />
                    </Col>
                    <Col sm={7}>
                      <Row>
                        <Col sm={12}>
                          <div className="d-flex align-items-center mt-3 mb-2">
                            <h5>
                              <PatchCheck
                                style={{ color: "red", marginLeft: '1px' }}
                              ></PatchCheck>{" "}
                              {Array(review.rating || 0)
                                .fill()
                                .map((_, index) => (
                                  <span
                                    key={index}
                                    className="fs-5 ms-1 text-center"
                                  >
                                    <StarFill
                                      style={{ color: "gold" }}
                                    ></StarFill>
                                  </span>
                                ))}
                            </h5>
                          </div>
                        </Col>
                        <Col sm={12}>
                          <div className="d-flex align-items-cente mx-1">
                            <LikesReview
                            reviewUsername={review.username}
                            recipeId={id}
                            reviewId={review._id}
                            initialLikes={review.likes || 0}
                            likedBy={review.liked_by}
                            reloadReviews={reloadReviews}
                            />
                            {currentUser === review.username && (
                              <>
                                <PencilSquare
                                  className="ms-2 mt-1"
                                  style={{ color: 'blue', cursor: 'pointer' }}
                                  onClick={() => handleOpenModalReview(review, 'Edit')}
                                />
                                <Trash
                                  className="ms-2 mt-1"
                                  style={{ color: 'red', cursor: 'pointer' }}
                                  onClick={() => handleOpenModalReview(review, 'Trash')}
                                />
                              </>
                            )} 
                          </div>
                        </Col>
                      </Row>
                    </Col>
                  </Row> 
                  : 
                  <Row>
                    <Col sm={12}>
                      <div className="fw-bold" style={{ cursor: 'pointer' }} onClick={() => handleNavigate(review.username)}>
                        {review.username}:{" "}
                      </div>
                    </Col>
                    <Col sm={5} className="mt-1" style={{ wordWrap: "break-word" }}>{review.comment}</Col>
                    <Col sm={7}>
                      <Row>
                        <Col sm={12}>
                          <div className="d-flex align-items-center mt-1">
                            <h5>
                              <PatchCheck
                                style={{ color: "red", marginLeft: '1px' }}
                              ></PatchCheck>{" "}
                              {Array(review.rating || 0)
                                .fill()
                                .map((_, index) => (
                                  <span
                                    key={index}
                                    className="fs-5 ms-1 text-center"
                                  >
                                    <StarFill
                                      style={{ color: "gold" }}
                                    ></StarFill>
                                  </span>
                                ))}
                            </h5>
                          </div>
                        </Col>
                        <Col sm={12}>
                          <div className="d-flex align-items-cente mt-2 ms-1">
                            <LikesReview
                            reviewUsername={review.username}
                            recipeId={id}
                            reviewId={review._id}
                            initialLikes={review.likes || 0}
                            likedBy={review.liked_by}
                            reloadReviews={reloadReviews}
                            />
                            {currentUser === review.username && (
                              <>
                                <PencilSquare
                                  className="mt-1 ms-1"
                                  style={{ color: 'blue', cursor: 'pointer' }}
                                  onClick={() => handleOpenModalReview(review, 'Edit')}
                                />
                                <Trash
                                  className="ms-2 mt-1"
                                  style={{ color: 'red', cursor: 'pointer' }}
                                  onClick={() => handleOpenModalReview(review, 'Trash')}
                                />
                              </>
                            )} 
                          </div>
                        </Col>
                      </Row>
                    </Col>
                  </Row>}
                </li>
              ))
            ) : ( owner !== currentUser ? 
              (<div className="text-center mt-5">
                <h4 className="mb-3">There are currently no reviews</h4>
                <p>Be the first one to post a review and share your thoughts!</p>
                <Button className="mx-auto fs-6 bg-danger fw-bold border-secondary text-white" onClick={handleOpenModal}>
                  Post a review
                </Button>
                <PostReview
                  id={id}
                  show={showModal}
                  onHide={handleCloseModal}
                  reloadReviews={reloadReviews}
                /> 
              </div>) : <div className="text-center mt-5">
               <h4 className="mb-3">There are currently no reviews</h4>
                <p className="mb-3">You are the owner of the recipe you can't do reviews </p>
                </div>
            )}
          </ul>
        </Container>
      </Col>
      <ImageModal
        show={showModalImage}
        onHide={handleCloseModalImage}
        recipeImage={selectedImage}
        recipeName={selectedImage ? "Image" : null} 
      />
      {selectedReview && (
        <ModifyReview
          show={showModalReview}
          reviewId={selectedReview._id}
          recipeId={id}
          onHide={handleCloseModalReview}
          reloadReviews={reloadReviews}
          funct={selectedFunct}
          reviewInfo={selectedReview}
        />
      )}
    </Container>
  );
}

export default Reviews;
