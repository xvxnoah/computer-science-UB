import { Card, Image, Row, Col } from "react-bootstrap";
import { StarFill } from "react-bootstrap-icons";
import "../css/UserFeed.css";
import chefIcon from "../assets/icons/chef.png";
import gyoza from "../assets/gyozas.jpg";

function SimilarRecipes({ recipe }) {
    return (
        <Card className="mt-5 shadow" id="recipes-list">
          <Card.Img
            className="object-fit-cover"
            variant="top"
            src={recipe.main_image ?? gyoza}
            height={300}
          />
          <Card.Body className="justify-content">
            <Row>
                <Col sm={12} className="d-flex">
                    <Card.Title className="overflow-hidden text-nowrap pb-1">
                        {recipe.name}
                    </Card.Title>
                </Col>
                <Col sm={12} className="d-flex">
                    <Image
                        src={chefIcon}
                        style={{ height: "24px", width: "24px"}}
                        fluid
                        className="mt-1 mb-3"
                    />
                    <h5 className="mt-1 mb-3">
                    {Array(recipe.difficulty || 0)
                        .fill()
                        .map((_, index) => (
                        <span key={index} className="fs-5 ms-1 text-center">
                            <StarFill style={{ color: "gold" }}></StarFill>
                        </span>
                        ))}
                    </h5>
                </Col>
                <Col sm={12} className="d-flex">
                    <StarFill className="mx-1 mt-1" style={{ color: "red" }}></StarFill>
                    <span>{recipe?.average_rating?.toFixed(1) || 0}</span>
                </Col>
            </Row>
          </Card.Body>
          <Card.Footer className="mt-auto">By {recipe?.username}</Card.Footer>
        </Card>
      );
        
  }
  
  export default SimilarRecipes;
