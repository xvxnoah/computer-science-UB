import React, { useState, useEffect } from "react";
import { Tooltip, OverlayTrigger, Container, Row, Col, Dropdown, Form, Button } from "react-bootstrap";
import { InfoCircleFill } from "react-bootstrap-icons";

const PrivacySettings = ({
    onClose,
    handleSaveProfile,
    handleVisibilityChange,
    imPrivate,
    usernameValidationMessage,
    emailValidationMessage,
    userNameAux,
    userMailAux,
    userBioAux,
    usernameValid,
    emailValid,
    usernameValidated,
    emailValidated,
    onUsernameChange,
    onEmailChange,
    setUserBioAux
}) => {

    const renderTooltip = (message) => (
        <Tooltip id="button-tooltip">{message}</Tooltip>
    );

    useEffect(() => {
        console.error(usernameValid==true)
      }, [usernameValid]);

    return (
        <Container className="form-container p-4">
            <Row>
                <Col sm={12}>
                    <Form>
                        {/* Sección de edición de perfil */}
                        <Form.Group className="mb-3">
                            <Form.Label>Username</Form.Label>
                            <Form.Control
                                type="text"
                                value={userNameAux}
                                onChange={(e) => onUsernameChange(e)}
                                isInvalid={usernameValidated && !usernameValid}
                            />
                            <Form.Control.Feedback type="invalid">
                                {usernameValidationMessage}
                            </Form.Control.Feedback>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Email</Form.Label>
                            <Form.Control
                                type="email"
                                value={userMailAux}
                                onChange={(e) => onEmailChange(e)}
                                isInvalid={emailValidated && !emailValid}
                            />
                            <Form.Control.Feedback type="invalid">
                                {emailValidationMessage}
                            </Form.Control.Feedback>
                        </Form.Group>
                        <Form.Group className="mb-3">
                            <Form.Label>Biography</Form.Label>
                            <Form.Control
                                as="textarea"
                                rows={3}
                                value={userBioAux}
                                onChange={(e) => setUserBioAux(e.target.value)}
                            />
                        </Form.Group>
                        {/* Botón para guardar cambios */}
                        <Button className="mb-3 mt-3" variant="primary" onClick={handleSaveProfile} disabled={!usernameValid || !emailValid} >
                            Save Changes
                        </Button>
                    </Form>

                    <hr/>
                    <Row className="privacy-section align-items-center mt-4">
                        <Col sm={3}>
                            <h5>Profile Visibility:</h5>
                        </Col>
                        <Col sm={2}>
                            <Dropdown>
                                <Dropdown.Toggle
                                    id="dropdown-visibility-button"
                                    variant={!imPrivate ? "outline-primary" : "outline-secondary"}>
                                    {imPrivate ? "Private" : "Public"}
                                </Dropdown.Toggle>

                                <Dropdown.Menu>
                                    <Dropdown.Item onClick={() => handleVisibilityChange(false)}>
                                        <OverlayTrigger
                                            placement="right"
                                            overlay={renderTooltip("Public profiles can be viewed by anyone.")}>
                                            <span>Public <InfoCircleFill className="ms-1" /></span>
                                        </OverlayTrigger>
                                    </Dropdown.Item>

                                    <Dropdown.Item onClick={() => handleVisibilityChange(true)}>
                                        <OverlayTrigger
                                            placement="right"
                                            overlay={renderTooltip("Private profiles can only be viewed by approved followers.")}>
                                            <span>Private <InfoCircleFill className="ms-1" /></span>
                                        </OverlayTrigger>
                                    </Dropdown.Item>
                                </Dropdown.Menu>
                            </Dropdown>
                        </Col>
                    </Row>
                </Col>
            </Row>
        </Container>
    );
};

export default PrivacySettings;
