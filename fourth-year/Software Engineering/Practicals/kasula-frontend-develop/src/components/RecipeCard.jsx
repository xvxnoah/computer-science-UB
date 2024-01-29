//Bootstrap
import { Card, Image } from "react-bootstrap";
import { StarFill } from "react-bootstrap-icons";

//CSS
import "../css/UserFeed.css";

//Assets
import chefIcon from "../assets/icons/chef.png";
import gyoza from "../assets/gyozas.jpg";

function RecipeCard({ recipe }) {
  return (
    <Card className="mt-5 shadow" id="recipes-list">
      <Card.Img
        className="object-fit-cover"
        variant="top"
        src={recipe.main_image ?? gyoza}
        height={300}
      />
      <Card.Body>
        <Card.Title className="overflow-hidden text-nowrap pb-1">
          {recipe.name}
        </Card.Title>
        <h5>
          <Image
            src={chefIcon}
            style={{ height: "24px", width: "24px" }}
            fluid
          />{" "}
          {Array(recipe.difficulty || 0)
            .fill()
            .map((_, index) => (
              <span key={index} className="fs-5 ms-1 text-center">
                <StarFill style={{ color: "gold" }}></StarFill>
              </span>
            ))}
        </h5>
        <div className="d-flex">
          <StarFill className="mx-1 mt-1" style={{ color: "red" }}></StarFill>
          <span>{recipe?.average_rating?.toFixed(1) || 0}</span>
        </div>
      </Card.Body>
      <Card.Footer>By {recipe?.username}</Card.Footer>
    </Card>
  );
}

export default RecipeCard;
