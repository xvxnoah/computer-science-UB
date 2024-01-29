//Logic packages
import { useState } from "react";
import { useNavigate } from "react-router-dom";

//React components
import { Container, Row, Col, Button, Form, Image } from "react-bootstrap";
import { ArrowLeft } from "react-bootstrap-icons";

//Styles
import "../css/common.css";

//Assets
import logo from "../assets/logo.png";

function PasswordRecovery() {
  const [email, setEmail] = useState("");
  const [emailValid, setEmailValid] = useState(false);
  const [emailValidated, setEmailValidated] = useState(false);
  const [emailErrorMessage, setEmailErrorMessage] = useState(
    "This field is required"
  );

  const navigate = useNavigate();

  const isEmailValid = (email = "") => {
    if (email.length === 0) {
      setEmailErrorMessage("This field is required");
      setEmailValid(false);
    } else if (email.search(/^[^\s@]+@[^\s@]+\.[^\s@]+$/) < 0) {
      setEmailErrorMessage("Please enter a valid email address");
      setEmailValid(false);
    } else {
      setEmailErrorMessage("");
      setEmailValid(true);
    }
    setEmailValidated(true);
  };

  const checkEmailExistance = async () => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/user/check_email/".concat(email),
        {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        }
      );
      if (!response.ok) {
        const data = await response.json();
        setEmailValid(false);
        if (data && data.detail) {
          setEmailErrorMessage(data.detail);
        } else {
          setEmailErrorMessage(
            "Could not check email. Please try again later."
          );
        }
      } else {
        const data = await response.json();
        setEmailValid(!data.status);
        if (data.status) {
          setEmailErrorMessage("Email does not exist.");
        } else {
          sendEmailRequest();
        }
      }
    } catch (error) {
      setEmailErrorMessage("Could not check email. Please try again later.");
      setEmailValid(false);
    }
  };

  const sendEmailRequest = async () => {
    try {
      const response = await fetch(
        process.env.REACT_APP_API_URL + "/user/password_recovery/",
        {
          method: "POST",
          headers: {
            "Content-Type": "application/json",
          },
          body: JSON.stringify({ email: email }),
        }
      );
      if (!response.ok) {
        console.log(response);
        const data = await response.json();
        setEmailValid(false);
        if (data && data.detail) {
          setEmailErrorMessage(data.detail);
        } else {
          setEmailErrorMessage("Could not send email. Please try again later.");
        }
      } else {
        navigate("/passwordrecovery/set", {
          state: { email: email },
        });
      }
    } catch (error) {
      setEmailErrorMessage("Could not send email. Please try again later.");
      setEmailValid(false);
    }
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    if (emailValid) {
      checkEmailExistance();
    }
    setEmailValidated(true);
  };

  return (
    <div>
      <Container className="py-5 min-vh-100">
        <Row>
          <Col sm={4}></Col>
          <Col sm={4} className="form-container rounded">
            <Row>
              <Col sm={1}>
                <Button
                  variant="link"
                  className="text-decoration-none fs-3 text-reset my-2"
                  onClick={() => navigate("/login")}
                >
                  <ArrowLeft></ArrowLeft>
                </Button>
              </Col>
              <Col sm={11}></Col>
            </Row>
            <Row>
              <Col sm={4}></Col>
              <Col sm={4}>
                <Image className="mb-4" src={logo} fluid />
              </Col>
              <Col sm={4}></Col>
            </Row>
            <Row className="mb-4">
              <Col>
                <h1 className="text-center fs-3">Password Recovery</h1>
              </Col>
            </Row>
            <Row className="px-4">
              <Col>
                <Form noValidate onSubmit={handleSubmit}>
                  <Form.Group className="mb-5" controlId="formEmail">
                    <Form.Label>Email address</Form.Label>
                    <Form.Control
                      className={
                        emailValidated
                          ? emailValid
                            ? "is-valid"
                            : "is-invalid"
                          : ""
                      }
                      type="email"
                      placeholder="Type your email"
                      value={email}
                      onChange={(e) => {
                        setEmail(e.target.value);
                        isEmailValid(e.target.value);
                        if (e.target.value.length === 0) {
                          setEmailValidated(false);
                        }
                      }}
                    />
                    <Form.Control.Feedback type="invalid">
                      {emailErrorMessage}
                    </Form.Control.Feedback>
                  </Form.Group>
                  <Row>
                    <Col sm={3}></Col>
                    <Col sm={6}>
                      <Button
                        className="w-100 mb-4 border-0"
                        variant="primary"
                        type="submit"
                        id="mainButton"
                      >
                        Send email
                      </Button>
                    </Col>
                    <Col sm={3}></Col>
                  </Row>
                </Form>
              </Col>
            </Row>
          </Col>
          <Col sm={4}></Col>
        </Row>
      </Container>
    </div>
  );
}

export default PasswordRecovery;
