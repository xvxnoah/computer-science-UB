import React from "react";
import { Modal } from "react-bootstrap";

function ImageModal({ show, onHide, recipeImage, recipeName }) {
  return (
    <Modal show={show} onHide={onHide} size="lg">
      <div id="carouselExampleSlidesOnly" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner">
          <div class="carousel-item active">
            <img src={recipeImage} class="d-block w-100" alt={recipeName} />
          </div>
        </div>
      </div>
    </Modal>
  );
}

export default ImageModal;
