import React, { useState, useRef, useEffect } from "react";
import "../css/PostRecipe.css";
import "../css/Transitions.css";
import "../css/common.css";
import { TransitionGroup, CSSTransition } from "react-transition-group";
import { useAuth } from "./AuthContext";
import { useNavigate } from "react-router-dom";
import FloatingLabel from "react-bootstrap/FloatingLabel";
import {
  CheckCircleFill,
  ExclamationTriangleFill,
  StarFill,
  Star,
  PlusSquareFill,
  TrashFill,
  XCircleFill,
} from "react-bootstrap-icons";

//React Components
import {
  Container,
  Row,
  Col,
  Button,
  Form,
  Image,
  Modal,
  Table,
} from "react-bootstrap";

const RecipePost = ({onClose, edit, id}) => {
  const { token } = useAuth();

  const Unit = {
    cup: "cup",
    tbsp: "tbsp",
    tsp: "tsp",
    oz: "oz",
    lb: "lb",
    g: "g",
    kg: "kg",
    ml: "ml",
    l: "l",
    pt: "pt",
    qt: "qt",
    gal: "gal",
    count: "count",
  };

  const [recipeName, setRecipeName] = useState("");
  const [ingredients, setIngredients] = useState([]);
  const [preparation, setPreparation] = useState([]);
  const [time, setTime] = useState(0);
  const [energy, setEnergy] = useState(0);
  const [difficulty, setDifficulty] = useState(1);
  const ingredientNameRef = useRef(null);
  const ingredientQuantityRef = useRef(null);
  const instructionRef = useRef(null);
  const ingredientUnitRef = useRef(null);
  const navigate = useNavigate();
  const [image, setImage] = useState(null);
  const [showPostRecipeConfirmation, setShowPostRecipeConfirmation] =
    useState(false);
  const [postSuccess, setPostRecipeSuccess] = useState(false);
  const [submitMessage, setSubmitMessage] = useState("");
  const [isIngredientFieldsFilled, setIsIngredientFieldsFilled] =
    useState(false);
  const [isInstructionFieldFilled, setIsInstructionFieldFilled] =
    useState(false);
  const [isPostButtonEnabled, setIsPostButtonEnabled] = useState(true);
  const [imagePreviewUrl, setImagePreviewUrl] = useState('');

  useEffect(() => {
    if (localStorage.getItem("logged") === "false") {
      navigate("/login");
    }
  }, [localStorage.getItem("logged"), navigate]);

  useEffect(() => {
    if(edit){
      fetchRecipeData();
    }
  }, []);

  const fetchRecipeData = async () => {
    try {
      const response = await fetch(`${process.env.REACT_APP_API_URL}/recipe/${id}`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      });
  
      if (!response.ok) {
        throw new Error('Error fetching recipe data');
      }
  
      const data = await response.json();
  
      setRecipeName(data.name);
      setIngredients(data.ingredients);
      setPreparation(data.instructions); 
      setTime(data.cooking_time);
      setEnergy(data.energy);
      setDifficulty(data.difficulty);
      setImagePreviewUrl(data.main_image)
  
    } catch (error) {
      console.error('Error:', error);
    }
  };
  

  const renderStars = (amount) => {
    let stars = [];
    for (let i = 1; i <= 5; i++) {
      stars.push(
        <span
          key={i}
          className={"difficulty-star "
            .concat(i <= amount ? "active" : "inactive")
            .concat(" ms-2 fs-4")}
          role="button"
          onClick={() => setDifficulty(i)}
        >
          {i <= amount ? <StarFill /> : <Star />}
        </span>
      );
    }
    return stars;
  };

  const handleIngredientDelete = (index) => {
    const newIngredients = [...ingredients];
    newIngredients.splice(index, 1);
    setIngredients(newIngredients);
    checkPostButtonConditions();
  };

  const convertTimeToMinutes = (timeStr) => {
    const [hours, minutes] = timeStr.split(":").map(Number);
    return hours * 60 + minutes;
  };

  const handleIngredientChange = (index, field, value) => {
    const newIngredients = [...ingredients];

    if (!newIngredients[index]) {
      newIngredients.push({ name: "", quantity: "", unit: "cup" });
    }

    newIngredients[index][field] = value;
    setIngredients(newIngredients);
  };

  const addIngredientField = () => {
    if (!isIngredientFieldsFilled) return;
    const newIngredient = {
      name: ingredientNameRef.current.value,
      quantity: ingredientQuantityRef.current.value,
      unit: ingredientUnitRef.current.value,
    };
    setIngredients([...ingredients, newIngredient]);
    ingredientNameRef.current.value = "";
    ingredientQuantityRef.current.value = "";
    setIsIngredientFieldsFilled(false);
    checkPostButtonConditions();
  };

  const handleInstructionChange = (index, value) => {
    const newInstructions = [...preparation];
    if (index >= newInstructions.length) {
      newInstructions.push({
        body: value,
        step_number: newInstructions.length + 1,
      });
    } else {
      newInstructions[index] = { ...newInstructions[index], body: value };
    }
    setPreparation(newInstructions);
  };

  const addInstructionField = () => {
    if (!isInstructionFieldFilled) return;
    const newInstruction = {
      body: instructionRef.current.value,
      step_number: preparation.length + 1,
    };
    setPreparation([...preparation, newInstruction]);
    instructionRef.current.value = "";
    setIsInstructionFieldFilled(false);
    checkPostButtonConditions();
  };

  const handleInstructionDelete = (index) => {
    const newInstructions = [...preparation];
    newInstructions.splice(index, 1);
    newInstructions.forEach((inst, idx) => {
      inst.step_number = idx + 1;
    });
    setPreparation(newInstructions);
    checkPostButtonConditions();
  };

  const validateRecipeData = (data) => {
    if (!data.name) return "Name is required!";
    if (!data.cooking_time) return "Cooking time is required!";
    if (!data.difficulty) return "Difficulty is required!";
    if (!data.energy) return "Energy is required!";
    if (!data.ingredients) return "Ingredients are required!";
    if (!data.instructions) return "Instructions are required!";

    return null;
  };

  const checkIngredientFields = () => {
    const nameFilled = ingredientNameRef.current.value.length > 0;
    const quantityFilled = ingredientQuantityRef.current.value > 0;
    const unitFilled = ingredientUnitRef.current.value.length > 0;
    setIsIngredientFieldsFilled(nameFilled && quantityFilled && unitFilled);
  };

  const checkInstructionField = () => {
    setIsInstructionFieldFilled(instructionRef.current.value.length > 0);
  };

  const checkPostButtonConditions = () => {
    // Asumiendo que 'time' y 'energy' son cadenas que representan números enteros
    const timeInt = parseInt(time, 10); // Convierte 'time' a entero base 10
    const energyInt = parseInt(energy, 10); // Convierte 'energy' a entero base 10

    // Verifica que tanto 'timeInt' como 'energyInt' sean mayores que 0
    // y que no sean NaN (lo cual ocurriría si 'time' o 'energy' no fueran cadenas numéricas)
    const areConditionsMet =
      recipeName.length > 0 &&
      ingredients.length > 0 &&
      preparation.length > 0 &&
      !isNaN(timeInt) &&
      timeInt > 0 &&
      !isNaN(energyInt) &&
      energyInt > 0;
    console.log(recipeName);
    setIsPostButtonEnabled(areConditionsMet);
  };

  const handleSubmit = async () => {
    const recipeData = {
      name: recipeName,
      cooking_time: time,
      difficulty: difficulty,
      energy: parseInt(energy),
      ingredients: ingredients,
      instructions: preparation,
    };

    const errorMessage = validateRecipeData(recipeData);
    if (errorMessage) {
      alert(errorMessage);
      return;
    }

    const formData = new FormData();
    formData.append("recipe", JSON.stringify(recipeData));
    if (image) {
      formData.append("files", image);
      
    }
    console.log(formData["recipe"]);
    if(edit){
      try {
        const response = await fetch(process.env.REACT_APP_API_URL + "/recipe/" + id, {
          method: "PUT",
          headers: {
            Authorization: `Bearer ${token}`,
          },
          body: formData,
        });
  
        const data = await response.json();
  
        if (response.ok) {
          setSubmitMessage("Updated correctly!", data);
          setPostRecipeSuccess(true);
          //onClose();
        } else {
          setSubmitMessage("Error updating recipe: " + JSON.stringify(data));
        }
      } catch (error) {
        setSubmitMessage(JSON.stringify(error));
        setPostRecipeSuccess(false);
      } finally {
        setShowPostRecipeConfirmation(true);
      }
    }else{
      try {
        const response = await fetch(process.env.REACT_APP_API_URL + "/recipe/", {
          method: "POST",
          headers: {
            Authorization: `Bearer ${token}`,
          },
          body: formData,
        });
  
        const data = await response.json();
  
        if (response.ok) {
          setSubmitMessage("Posted correctly!", data);
          setPostRecipeSuccess(true);
          //onClose();
        } else {
          setSubmitMessage("Error posting recipe: " + JSON.stringify(data));
        }
      } catch (error) {
        setSubmitMessage(JSON.stringify(error));
        setPostRecipeSuccess(false);
      } finally {
        setShowPostRecipeConfirmation(true);
      }
    }
    
  };

  const handleImageUpload = (event) => {
    const file = event.target.files[0];
    setImage(file);
    const imageUrl = URL.createObjectURL(file);
    setImagePreviewUrl(imageUrl);
  };

  const handlePostRecipeConfirmationClose = () => {
    setShowPostRecipeConfirmation(false);
    if (postSuccess) {
      onClose();
    }
  };

  return (
    <div>
      <Container className="form-container p-4">
          <Row>
              {/* <CSSTransition
                in={true}
                timeout={500}
                classNames="slideUp"
                appear
              >
                <Container
                  id="recipe-container"
                  className="mt-3 rounded box-shadow"
                >
                  <Row>
                    <Col
                      xs={12}
                      className="ingredient-list overflow-x-hidden overflow-y-auto"
                    >
                      <TransitionGroup component={null}>
                        {ingredients.map((ingredient, index) => (
                          <CSSTransition
                            key={index}
                            timeout={500}
                            classNames="ingredient-fade"
                          >
                            <Row>
                              <Col xs={9}>
                                <span>
                                  {ingredient.name} - {ingredient.quantity}{" "}
                                  {ingredient.unit}
                                </span>
                              </Col>
                              <Col xs={3}>
                                <Button
                                  id="buttons_remove"
                                  variant="danger"
                                  onClick={() => handleIngredientDelete(index)}
                                >
                                  X
                                </Button>{" "}
                              </Col>
                            </Row>
                          </CSSTransition>
                        ))}
                      </TransitionGroup>
                    </Col>
                  </Row>
                </Container>
              </CSSTransition> */}

            <Col sm={12}>
              <CSSTransition
                in={true}
                timeout={500}
                classNames="slideUp"
                appear
              >
                <Container id="recipe-container" className="rounded">
                  <Row className="mb-4">
                    <Col sm={12}>
                      <FloatingLabel
                        controlId="floatingInput"
                        label="Recipe name"
                        className="mb-3 mt-3"
                      >
                        <Form.Control
                          placeholder="name@example.com"
                          value={recipeName}
                          onChange={(e) => setRecipeName(e.target.value)}
                        />
                      </FloatingLabel>
                    </Col>
                  </Row>
                  <Row>
                    <label>INGREDIENTS</label>
                    <Row className="mt-2 mb-4 pe-0">
                      <Col sm={6} className="pe-0">
                        <Form.Control
                          placeholder="Name"
                          ref={ingredientNameRef}
                          onChange={checkIngredientFields}
                        />
                      </Col>
                      <Col sm={3} className="pe-0">
                        <Form.Control
                          type="number"
                          placeholder="Quantity"
                          ref={ingredientQuantityRef}
                          min={0}
                          onChange={checkIngredientFields}
                        />
                      </Col>
                      <Col sm={2} className="ps-0">
                        <Form.Select
                          ref={ingredientUnitRef}
                          aria-label="Ingredient Unit Selection"
                        >
                          {Object.values(Unit).map((unit) => (
                            <option key={unit} value={unit}>
                              {unit}
                            </option>
                          ))}
                          onChange={checkIngredientFields}
                        </Form.Select>
                      </Col>
                      <Col sm={1} className="pe-0 text-end">
                        <span
                          className={"add-ingredient-button"
                            .concat(
                              isIngredientFieldsFilled ? " active" : " inactive"
                            )
                            .concat(" text-center fs-4")}
                          role="button"
                          onClick={addIngredientField}
                        >
                          <PlusSquareFill></PlusSquareFill>
                        </span>
                      </Col>
                    </Row>
                    <Row className="mb-4 pe-0">
                      {ingredients.length > 0 ? (
                        <Col sm={12} className="pe-0">
                          <Table striped bordered hover>
                            <thead>
                              <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Quantity</th>
                                <th>Unit</th>
                                <th className="text-center">
                                  <TrashFill></TrashFill>
                                </th>
                              </tr>
                            </thead>
                            <tbody>
                              {ingredients.map((ingredient, index) => (
                                <tr key={index}>
                                  <td>{index + 1}</td>
                                  <td>{ingredient.name}</td>
                                  <td>{ingredient.quantity}</td>
                                  <td>{ingredient.unit}</td>
                                  <td className="text-center">
                                    <span
                                      className="remove-ingredient-button"
                                      role="button"
                                      onClick={() => {
                                        handleIngredientDelete(index);
                                      }}
                                    >
                                      <XCircleFill></XCircleFill>
                                    </span>
                                  </td>
                                </tr>
                              ))}
                            </tbody>
                          </Table>
                        </Col>
                      ) : (
                        <p className="mx-2">
                          No ingredients added yet, use the fields above to add
                          a new ingredient.
                        </p>
                      )}
                    </Row>
                    <label>PREPARATION</label>
                    <Row className="mt-2 mb-4 pe-0">
                      <Col sm={11}>
                        <Form.Control
                          type="text"
                          as="textarea"
                          ref={instructionRef}
                          placeholder={`Step ${
                            preparation.length > 0 ? preparation.length + 1 : 1
                          }`}
                          maxLength={2000}
                          onChange={checkInstructionField}
                        />
                      </Col>
                      <Col sm={1} className="pe-0 text-end">
                        <span
                          className={"add-ingredient-button"
                            .concat(
                              isInstructionFieldFilled ? " active" : " inactive"
                            )
                            .concat(" text-center fs-4")}
                          role="button"
                          onClick={addInstructionField}
                        >
                          <PlusSquareFill></PlusSquareFill>
                        </span>
                      </Col>
                    </Row>
                    <Row className="mb-4">
                      {preparation.length > 0 ? (
                        <Col sm={12}>
                          <h5 className="fw-semibold fs-6 mb-3">
                            Preparation Steps
                          </h5>
                          {preparation.map((step, index) => (
                            <Container>
                              <Row className="mb-2">
                                <Col sm={11}>
                                  <h6 key={index} className="fw-normal fs-6">
                                    Step {index + 1}:
                                  </h6>
                                </Col>
                                <Col sm={1} className="text-center">
                                  <span
                                    className="remove-ingredient-button"
                                    role="button"
                                    onClick={() => {
                                      handleInstructionDelete(index);
                                    }}
                                  >
                                    <XCircleFill></XCircleFill>
                                  </span>
                                </Col>
                              </Row>
                              <Container>
                                <p className="text-break">{step.body}</p>
                              </Container>
                              <hr></hr>
                            </Container>
                          ))}
                        </Col>
                      ) : (
                        <p className="mx-2">
                          No steps added yet, use the fields above to add a new
                          step.
                        </p>
                      )}
                    </Row>
                  </Row>
                  <Row>
                    <Col xs={6} md={6} lg={6}>
                      <Row>
                        <Form.Group controlId="formFile" className="mb-3">
                          <Form.Label>Upload an image</Form.Label>
                          <Form.Control
                            type="file"
                            onChange={handleImageUpload}
                          />
                        </Form.Group>
                      </Row>
                    </Col>
                    <Col xs={6} md={6} lg={6}>
                      <Row>
                        <Form.Group className="mb-3">
                          <Form.Label>Cooking time (minutes)</Form.Label>
                          <Form.Control
                            placeholder={`Minutes`}
                            value={time}
                            type="number"
                            min={0}
                            onChange={(e) => {
                              setTime(e.target.value);
                              checkPostButtonConditions();
                            }}
                          />
                        </Form.Group>
                      </Row>
                    </Col>
                    <Col xs={6} md={6} lg={6}>
                      <Row>
                          {imagePreviewUrl && <img src={imagePreviewUrl} alt="Uploaded" />}
                      </Row>
                    </Col>
                    <Col xs={6}>
                      <Row>
                        <Form.Group className="mb-3">
                          <Form.Label>Energy (kcal)</Form.Label>
                          <Form.Control
                            type="number"
                            placeholder={`Kcal`}
                            value={energy}
                            min={0}
                            onChange={(e) => {
                              setEnergy(e.target.value);
                              checkPostButtonConditions();
                            }}
                          />
                        </Form.Group>
                      </Row>
                      <Row>
                        <label>Difficulty</label>
                        <div>{renderStars(difficulty)}</div>
                      </Row>
                    </Col>
                  </Row>
                  <Row>
                    <Col xs={5}></Col>
                    <Col xs={4}>
                      <Button
                        className="mt-4 mb-2 border-0"
                        style={{ marginTop: "10px" }}
                        onClick={handleSubmit}
                        id="mainButton"
                      >
                        POST
                      </Button>{" "}
                    </Col>
                    <Col xs={4}></Col>
                  </Row>
                </Container>
              </CSSTransition>
            </Col>
              {/* <CSSTransition
                in={true}
                timeout={500}
                classNames="slideUp"
                appear
              >
                <Container
                  id="recipe-container"
                  className="mt-3 rounded box-shadow"
                >
                  <Row>
                    <Col xs={12} md={12} lg={12}>
                      <div className="preparation-list overflow-y-auto">
                        <TransitionGroup component={null}>
                          {preparation.map((step, index) => (
                            <CSSTransition
                              key={index}
                              timeout={500}
                              classNames="ingredient-fade"
                            >
                              <div key={index}>
                                <Row>
                                  <Col xs={9} md={9} lg={9}>
                                    <span>
                                      Step {step.step_number}: {step.body}
                                    </span>
                                  </Col>
                                  <Col xs={3} md={3} lg={3}>
                                    <Button
                                      id="buttons_remove"
                                      variant="danger"
                                      onClick={() =>
                                        handleInstructionDelete(index)
                                      }
                                    >
                                      X
                                    </Button>{" "}
                                  </Col>
                                </Row>
                              </div>
                            </CSSTransition>
                          ))}
                        </TransitionGroup>
                      </div>
                    </Col>
                  </Row>
                </Container>
              </CSSTransition> */}
          </Row>
      </Container>

      <Modal
        show={showPostRecipeConfirmation}
        size="sm"
        onHide={handlePostRecipeConfirmationClose}
      >
        <Modal.Header closeButton>
          <Modal.Title>
            {postSuccess ? "Confirm Posting" : "Posting Error"}
          </Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <Row>
            <Col className="text-center mb-4">
              {postSuccess ? (
                <CheckCircleFill className="text-success" size={100} />
              ) : (
                <ExclamationTriangleFill className="text-warning" size={100} />
              )}
            </Col>
          </Row>
          <Row>
            <Col className="text-center">
              <p>{submitMessage}</p>
            </Col>
          </Row>
        </Modal.Body>
        <Modal.Footer>
          <Button
            variant={postSuccess ? "success" : "secondary"}
            onClick={handlePostRecipeConfirmationClose}
          >
            {postSuccess ? "Okay" : "Close"}
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
};

export default RecipePost;