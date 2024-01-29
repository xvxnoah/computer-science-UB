//React
import React, { useState } from "react";
import { useAuth } from "./AuthContext";

//React Components
import { Container, Row, Col, Button, Form } from "react-bootstrap";

const CollectionCreate = ({ onClose, onMessage, recipe_id }) => {
  const { token } = useAuth();
  const [collection, setCollection] = useState({
    name: "",
    description: "",
    //image: "",
  });
  const [formValidations, setFormValidations] = useState({
    name: {
      isValid: false,
      showValidation: false,
      message: "You must provide a name for your collection.",
    },
  });

  const requestCreateCollection = async (request_body) => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/collection/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
            Authorization: `Bearer ${token}`,
          },
          body: request_body,
        }
      );
      const data = await response.json();
      console.log(data);
      if (response.ok) {
        onMessage("Collection created successfully!", "success");
      } else {
        onMessage(data.detail, "danger");
      }
    } catch (error) {
      console.error("Error:", error);
      onMessage(error, "danger");
    } finally {
      onClose();
    }
  };

  const performValidations = (show) => {
    setFormValidations((prevState) => ({
      ...prevState,
      name: {
        ...prevState.name,
        isValid: collection.name.length > 0,
        showValidation: show,
      },
    }));
  };

  const allValid = () => {
    return Object.values(formValidations).every((field) => field.isValid);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    performValidations(true);
    if (allValid()) {
      if (recipe_id) {
        requestCreateCollection(
          JSON.stringify({
            ...collection,
            recipe_ids: [recipe_id],
          })
        );
      } else {
        requestCreateCollection(
          JSON.stringify({
            ...collection,
          })
        );
      }
    }
  };

  return (
    <Container className="form-container p-4">
      <Row className="justify-content-center">
        <Col xs={12} md={8}>
          <Form onSubmit={handleSubmit} className="d-flex flex-column">
            <Form.Group className="mb-3" controlId="">
              <Form.Label>Name</Form.Label>
              <Form.Control
                className={
                  formValidations.name.isValid ||
                  !formValidations.name.showValidation
                    ? ""
                    : "is-invalid"
                }
                type="text"
                placeholder="Enter name"
                value={collection.name}
                onChange={(event) => {
                  setCollection({
                    ...collection,
                    name: event.target.value,
                  });
                  performValidations(false);
                }}
              />
              <Form.Control.Feedback type="invalid">
                You must provide a name for your collection.
              </Form.Control.Feedback>
            </Form.Group>
            <Form.Group className="mb-3">
              <Form.Label>Description</Form.Label>
              <Form.Control
                as="textarea"
                type="text"
                placeholder="Enter description"
                value={collection.description}
                onChange={(event) => {
                  setCollection({
                    ...collection,
                    description: event.target.value,
                  });
                }}
              />
            </Form.Group>
            {/* <Form.Group className="mb-3" controlId="formBasicEmail">
                            <Form.Label>Collection Image</Form.Label>
                            <Form.Control type="text" placeholder="Enter collection image url" />
                        </Form.Group> */}
            <Button
              className="w-25 my-4 border-0 ms-auto me-auto"
              variant="primary"
              type="submit"
              id="mainButton"
            >
              CREATE
            </Button>
          </Form>
        </Col>
      </Row>
    </Container>
  );
};

export default CollectionCreate;
