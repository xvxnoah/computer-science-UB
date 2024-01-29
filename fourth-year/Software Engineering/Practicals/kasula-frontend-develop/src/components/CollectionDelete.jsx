//React
import React from "react";
import { useAuth } from "./AuthContext";

//React Components
import { Container, Button, Row, Col } from "react-bootstrap";
import { ExclamationTriangleFill, Robot } from "react-bootstrap-icons";

const CollectionDelete = ({ onClose, onMessage, collection_id }) => {
  const { token } = useAuth();
  const requestDeleteCollection = async () => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/collection/" + collection_id + "/",
        {
          method: "DELETE",
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );
      const data = await response.json();
      console.log(data);
      if (response.ok) {
        onMessage("Collection deleted successfully!", "success");
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

  return (
    <Container className="p-4">
      <Row className="d-flex text-center">
        <Col xs={12} className="mb-3">
          <ExclamationTriangleFill className="text-warning" size={100} />
        </Col>
        <Col xs={12}>
          <span>Are you sure you want to delete this collection?</span>
        </Col>
        <Col xs={12}>
          <Button
            className="mt-4 border-0"
            onClick={() => requestDeleteCollection()}
            id="mainButton"
          >
            DELETE
          </Button>
        </Col>
      </Row>
    </Container>
  );
};

export default CollectionDelete;
