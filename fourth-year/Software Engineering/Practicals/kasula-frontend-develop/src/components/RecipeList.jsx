
import { CSSTransition } from "react-transition-group";
import { useRef, useEffect } from "react";
import { Link } from "react-router-dom";
import { Container, Row, Col } from "react-bootstrap";
import { X } from "react-bootstrap-icons";
import RecipeCard from "./RecipeCard";
import "../css/Transitions.css";

function RecipeList({ recipes, canDelete, onDeleteRecipe, onRequestLoadMore, id, token, finished }) {
  const myRef = useRef();
  useEffect(() => {
    const observer = new IntersectionObserver((entries) => {
      if (entries[0].isIntersecting && !finished) {
        onRequestLoadMore();
        observer.unobserve(entries[0].target);
      }
    });
    if (myRef.current) {
      observer.observe(myRef.current);
    }
    return () => {
      if (myRef.current) {
        observer.unobserve(myRef.current);
      }
    };
  }, [myRef, recipes]);
  return (
    <Container className="pb-5 pt-3">
      <Row>
        {recipes && recipes.length > 0 ? (
          recipes.map((recipe, index) => (
            <Col key={recipe._id} sm={12} md={6} xl={4}>
              <CSSTransition
                in={true}
                timeout={500}
                classNames="slideUp"
                appear
              >
                <div ref={(index === recipes.length - 6 ) ? myRef : null} className="position-relative transition-03s">
                  <Link
                    key={recipe._id}
                    to={`/RecipeDetail/${recipe._id}`}
                    className="text-decoration-none"
                  >
                    <RecipeCard recipe={recipe} />
                  </Link>
                  {canDelete && (
                    <span
                      className="fs-3 colorless-span-button position-absolute top-0 end-0 mx-2"
                      role="button"
                      onClick={() => {
                        fetch(
                          process.env.REACT_APP_API_URL +
                            `/collection/${id}/remove_recipe/${recipe._id}`,
                          {
                            method: "PUT",
                            headers: {
                              Authorization: `Bearer ${token}`,
                            },
                          }
                        )
                          .then((response) => response.json())
                          .then((data) => {
                            console.log(data);
                            onDeleteRecipe();
                          })
                          .catch((error) =>
                            console.error("Error al obtener recetas:", error)
                          );
                      }}
                    >
                      <X className="rounded-circle highlighter" />
                    </span>
                  )}
                </div>
              </CSSTransition>
            </Col>
          ))
        ) : (
          <div className="alert alert-warning" role="alert">
            {canDelete ? "There are currently no recipes" : "There are no recipes matching the search or filters"}
          </div>
        )}
      </Row>
    </Container>
  );
}

export default RecipeList;
