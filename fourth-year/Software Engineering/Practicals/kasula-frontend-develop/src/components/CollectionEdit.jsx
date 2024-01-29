//React
import { useState, useEffect } from "react";
import { useAuth } from "./AuthContext";

//React Components
import { Container, Row, Col, Button, Form } from "react-bootstrap";

const CollectionEdit = ({ onClose, onMessage, collection_to_edit }) => {
  const { token } = useAuth();
  const [collection, setCollection] = useState({
    id: collection_to_edit._id,
    name: collection_to_edit.name,
    description: collection_to_edit.description,
    //image: "",
  });

  useEffect(() => {
    performValidations(false);
  }, [collection]);

  const [initialCollectionValues] = useState(collection_to_edit);

  const [formValidations, setFormValidations] = useState({
    name: {
      isValid: false,
      showValidation: false,
      message: "You must provide a name for your collection.",
    },
  });

  const requestEditCollection = async (request_body) => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/collection/" + collection.id + "/",
        {
          method: "PUT",
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
        onMessage("Collection updated successfully!", "success");
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
      if (
        collection.description !== initialCollectionValues.description &&
        collection.name === initialCollectionValues.name
      ) {
        requestEditCollection(
          JSON.stringify({
            description: collection.description,
          })
        );
      } else if (
        collection.description === initialCollectionValues.description &&
        collection.name !== initialCollectionValues.name
      ) {
        requestEditCollection(
          JSON.stringify({
            name: collection.name,
          })
        );
      } else if (
        collection.description !== initialCollectionValues.description &&
        collection.name !== initialCollectionValues.name
      ) {
        requestEditCollection(
          JSON.stringify({
            name: collection.name,
            description: collection.description,
          })
        );
      } else {
        onClose();
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
                  console.log(collection.description);
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
              UPDATE
            </Button>
          </Form>
        </Col>
      </Row>
    </Container>
  );
};

export default CollectionEdit;
