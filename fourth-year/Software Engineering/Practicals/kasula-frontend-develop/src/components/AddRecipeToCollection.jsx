//React
import React, { useState, useEffect } from "react";
import { useAuth } from "./AuthContext";

//React Components
import { Container, Row, Col, ListGroup } from "react-bootstrap";

const AddRecipeToCollection = ({ onClose, onMessage, recipe_id }) => {
  const { token } = useAuth();
  const [collections, setCollections] = useState([]);

  useEffect(() => {
    if (localStorage.getItem("logged") === "true") {
      getLoggedUserData();
    }
  }, []);

  const getLoggedUserData = () => {
    fetch(process.env.REACT_APP_API_URL + "/user/me", {
      method: "GET",
      headers: {
        Authorization: `Bearer ${token}`,
      },
    })
      .then((response) => response.json())
      .then((data) => {
        console.log("User data:", data);
        getCollectionsData(data);
      })
      .catch((error) => console.error("Error when getting user:", error));
  };

  const getCollectionsData = (user) => {
    console.log(user);
    fetch(process.env.REACT_APP_API_URL + `/collection/user/${user.username}`)
      .then((response) => response.json())
      .then((data) => {
        console.log("Collections data:", data);
        //Use all collections except the ones with favorite set to true
        let filteredCollections = data.filter((collection) => !collection.favorite);
        setCollections(filteredCollections);
      })
      .catch((error) =>
        console.error("Error when getting collections:", error)
      );
  };

  const requestAddRecipeToCollection = (collection_id) => {
    fetch(process.env.REACT_APP_API_URL + `/collection/${collection_id}/add_recipe/${recipe_id}`, {
      method: "PUT",
      headers: {
        Authorization: `Bearer ${token}`,
      }
    })
      .then((response) => response.json())
      .then((data) => {
        console.log("Add recipe to collection response:", data);
        onMessage("Recipe added to collection", "success");
        onClose();
      })
      .catch((error) =>
        console.error("Error when adding recipe to collection:", error)
      );
  }

  return (
    <Container className="bg-lightest p-4">
      <Row className="justify-content-center">
        <Col xs={12}>
          <ListGroup>
            {collections.map((collection) => (
              <ListGroup.Item action key={collection.id} onClick={() => {
                requestAddRecipeToCollection(collection._id);
                }
              }>
                {collection.name}
              </ListGroup.Item>
            ))}
          </ListGroup>
        </Col>
      </Row>
    </Container>
  );
};

export default AddRecipeToCollection;
