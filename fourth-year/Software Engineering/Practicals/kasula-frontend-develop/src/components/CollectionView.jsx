//React
import React, { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router-dom";
import { useAuth } from "./AuthContext";

//Bootstrap
import { Link } from "react-router-dom";
import { Container, Spinner } from "react-bootstrap";
import { ArrowLeft } from "react-bootstrap-icons";

//Components
import RecipeList from "./RecipeList";

//CSS
import "../css/Transitions.css";

function CollectionView() {
  const { token, isLogged } = useAuth();
  const { id, name } = useParams();
  const [recipes, setRecipes] = useState([]);
  const [loading, setLoading] = useState(true);

  const navigate = useNavigate();

  useEffect(() => {
    setLoading(true);
    if (!isLogged()) {
      navigate("/login");
      setLoading(false);
    } else {
      getRecipes();
    }
  }, [id, name]);

  const getRecipes = () => {
    fetch(process.env.REACT_APP_API_URL + `/collection/${id}/recipes/`)
      .then((response) => response.json())
      .then((data) => {
        console.log(data);
        setRecipes(data);
        setLoading(false);
      })
      .catch((error) => { 
        console.error("Error al obtener recetas:", error);
        setLoading(false); 
      });
  };

  return (
    <Container className="pb-5 pt-3">
      <h1 className="text-center">{name}</h1>
      <Link to={"/collections"}>
        <span className="fs-3 colorless-span-button" role="button">
          <ArrowLeft></ArrowLeft>
        </span>
      </Link>
      {loading ? (
        <Container className="d-flex justify-content-center align-items-center mt-5">
          <Spinner animation="border" variant="secondary" />
        </Container>
      ) : (
        <RecipeList recipes={recipes} canDelete={true} id={id} token={token} onDeleteRecipe={getRecipes} />
      )}
    </Container>
  );
}

export default CollectionView;