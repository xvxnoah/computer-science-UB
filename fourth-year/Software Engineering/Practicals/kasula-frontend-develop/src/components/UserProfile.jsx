import { useAuth } from "./AuthContext";

// React
import React, { useState, useRef, useEffect } from "react";
import { CSSTransition } from "react-transition-group";
import { Link } from "react-router-dom";
import { useNavigate, useParams } from "react-router-dom";

// Images
import defaultProfile from "../assets/defaultProfile.png";
import chefIcon from "../assets/icons/chef.png";
import logo from "../assets/logo.png";

// Bootstrap
import { StarFill, Pencil, ExclamationTriangleFill, X, GearFill} from "react-bootstrap-icons";
import { Container, Row, Col, Card, Button, Form, Image, Modal, Dropdown, ListGroup } from "react-bootstrap";

// CSS
import "../css/common.css";
import "../css/UserProfile.css";
import PrivacySettings from "./PrivacySettings";

//Components
import PostRecipe from "./PostRecipe";

const UserProfile = () => {
  const { token, logout, isLogged } = useAuth();
  const navigate = useNavigate();
  const [operationSuccess, setOperationSuccess] = useState(false);


  const { userId } = useParams();
  const [updateCount, setUpdateCount] = useState(0);
  const [myUserId, setMyUserId] = useState('');
  const [myUserName, setMyUserName] = useState('');
  const [userName, setUserName] = useState('');
  const [userMail, setUserMail] = useState('');
  const [userBio, setUserBio] = useState('');
  const [userFollowers, setUserFollowers] = useState([]);
  const [userFollowing, setUserFollowing] = useState([]);
  const [myFollowing, setMyFollowing] = useState([]);
  const [userNameAux, setUserNameAux] = useState('');
  const [userMailAux, setUserMailAux] = useState('');
  const [userBioAux, setUserBioAux] = useState('');
  const [profilePicture, setProfilePicture] = useState('');

  const [usernameValid, setUsernameValid] = useState(true);
  const [usernameValidated, setUsernameValidated] = useState(true);
  const [emailValid, setEmailValid] = useState(true);
  const [emailValidated, setEmailValidated] = useState(true);

  const [usernameValidationMessage, setUsernameValidationMessage] = useState('');
  const [emailValidationMessage, setEmailValidationMessage] = useState('');
  const [isDoingRequest, setIsDoingRequest] = useState(false);
  const [isFollowing, setIsFollowing] = useState(null);
  const [followerDetails, setFollowerDetails] = useState([]);
  const [followingDetails, setFollowingDetails] = useState([]);
  const [imPrivate, setImPrivate] = useState(true); 
  const [userIsPrivate, setUserIsPrivate] = useState(true); 
  const [suggestedUsers, setSuggestedUsers] = useState([]);


  const [adminMode, setadminMode] = useState(false);
  const [editMode, setEditMode] = useState(false);
  const [showConfirmation, setShowConfirmation] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);
  const [showPrivacySettings, setShowPrivacySettings] = useState(false);
  const [showEditRecipe, setShowEditRecipe] = useState(false);
  const [showDropdown2, setShowDropdown2] = useState(false);
  const [showRemoveQuestion, setRemoveQuestion] = useState(false);
  const [showRemoveRecipeModal, setShowRemoveRecipeModal] = useState(false);
  const [selectedRecipeId, setSelectedRecipeId] = useState(null);
  const [showFollowersModal, setShowFollowersModal] = useState(false);
  const [showFollowingModal, setShowFollowingModal] = useState(false);
  const [showUnfollowModal, setShowUnfollowModal] = useState(false);
  const [showLoginRedirectModal, setShowLoginRedirectModal] = useState(false);



  const [confirmationMessage, setConfirmationMessage] = useState("");
  const [recipes, setRecipes] = useState([]);

  const handleNavigate = (userId) => {
    window.location.href = `/UserProfile/${userId}`;
  };

  
  const profileTitleStyle = {
    marginBottom: '5px',
  };
  
  const profileTextStyle = {
    marginBottom: '0',
  };
  
  const bioBoxStyle = {
    overflowY: 'auto',
    maxHeight: '200px',
    borderRadius: '0.25rem',
    padding: '0.375rem 0.75rem',
    lineHeight: '1.5',
    whiteSpace: 'pre-wrap',
    wordWrap: 'break-word'
  };

  const fetchMyUserData = async () => {
    try {
      const response = await fetch(process.env.REACT_APP_API_URL + '/user/me', {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
      if (!response.ok) {
        throw new Error('Failed to fetch user data');
      }
      const data = await response.json();
      setMyUserId(data._id)
      setMyUserName(data.username)
      setImPrivate(data.is_private)
      setMyFollowing(data.following)
    } catch (error) {
      console.error('Error fetching user data:', error);
    }
  };

  const isFollowed = (follower) => {
    return myFollowing.includes(follower.username);
  };

  const fetchUserData = async () => {
    try {
      const response = await fetch(process.env.REACT_APP_API_URL + '/user/' + userId, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
      if (!response.ok) {
        throw new Error('Failed to fetch user data');
      }
      const data = await response.json();

      setUserName(data.username);
      setUserNameAux(data.username);

      setUserMail(data.email)
      setUserMailAux(data.email)

      setUserBio(data.bio || '');
      setUserBioAux(data.bio || '');

      setUserFollowers(data.followers || []);
      setUserFollowing(data.following || []);

      setProfilePicture(data.profile_picture || '');

      setUserIsPrivate(data.is_private);
    } catch (error) {
      console.error('Error fetching user data:', error);
    }
  };

  const fetchUserDetails = async (usernames, setUserDetails) => {
    const userDetails = await Promise.all(
      usernames.map(async (username) => {
        const response = await fetch(process.env.REACT_APP_API_URL + `/user/${username}`);
        return response.json();
      })
    );
    setUserDetails(userDetails);
  };

  const fetchSuggestedUsers = async () => {
    try {
      const response = await fetch(process.env.REACT_APP_API_URL + `/user/new/discover`, {
        method: 'GET',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
      if (!response.ok) {
        throw new Error('Failed to fetch suggested users');
      }
      const data = await response.json();
      setSuggestedUsers(data);
    } catch (error) {
      console.error('Error fetching suggested users:', error);
    }
  };

  useEffect(() => {
    if (token!=null) {
      fetchMyUserData();
      fetchSuggestedUsers();
    }
  }, [token]);

  useEffect(() => {
    
    if(myUserId == userId){
      setadminMode(true);
    }
    fetchUserData();
  }, [myUserId]);

  useEffect(() => {
    if (userName) {
      getRecipes();
    }
  }, [userName, updateCount]);

  useEffect(() => {
    fetchUserDetails(userFollowers, setFollowerDetails);
    console.error(followerDetails)
  }, [userFollowers]);
  
  useEffect(() => {
    fetchUserDetails(userFollowing, setFollowingDetails);
  }, [userFollowing]);
  
  const handleEditToggle = () => {
    setEditMode(!editMode);
  };

  const handleCancelEdit = () => {
    fetchMyUserData();
    fetchUserData();
    setEditMode(false);
  };

  const handleCloseEditRecipeModal = () => {
    setShowEditRecipe(false);
    setUpdateCount(prevCount => prevCount + 1);
  };

  const handleCloseEditRecipeSuccessfulModal = () => {
    setShowEditRecipe(false);
    setUpdateCount(prevCount => prevCount + 1);
  };

  const handleShowRemoveRecipeModal = () => {
    setShowRemoveRecipeModal(true);
};

  const handleOpenPrivacySettings = () => {
    setShowPrivacySettings(true);
  };

  const handleClosePrivacySettings = () => {
    setEditMode(false);
  };

  const handleSaveProfile = async () => {

    if (!userNameAux) {
        setConfirmationMessage("Name is required");
        setShowConfirmation(true);
        return;
    }

    if (!usernameValid || !emailValid) {
      setConfirmationMessage("Please make sure that the username and email are valid.");
      setShowConfirmation(true);
      setOperationSuccess(false);
      return;
    }

    const formData = new FormData();
    const userProfile = {
        username: userNameAux,
        email: userMailAux,
        bio: userBioAux
    };
    
    // Convert the user profile object to a JSON string and append to FormData
    formData.append('user', JSON.stringify(userProfile));

    try {
        const response = await fetch(process.env.REACT_APP_API_URL + `/user/${userId}`, {
            method: 'PUT',
            headers: {
                'Authorization': `Bearer ${token}`
                // Note: 'Content-Type' header is not needed when using FormData
            },
            body: formData,
        });

        if (!response.ok) {
            throw new Error('Failed to update user data');
        }

        const updatedData = await response.json();

        setUserName(updatedData.username);
        setUserMail(updatedData.email);
        setUserBio(updatedData.bio || '');
        setOperationSuccess(true)

        setConfirmationMessage("Profile updated successfully");
    } catch (error) {
        console.error('Error updating user data:', error);
        setOperationSuccess(false)
        setConfirmationMessage("Oops! Something went wrong.");
    }

    setShowConfirmation(true);
    setEditMode(false);
};


const handleVisibilityChange = async (newVisibility) => {
  console.error(newVisibility)
  setImPrivate(newVisibility);
  const formData = new FormData();
  const userProfile = {
      is_private: newVisibility,
  };
  
  // Convert the user profile object to a JSON string and append to FormData
  formData.append('user', JSON.stringify(userProfile));

  try {
      const response = await fetch(process.env.REACT_APP_API_URL + `/user/${userId}`, {
          method: 'PUT',
          headers: {
              'Authorization': `Bearer ${token}`
          },
          body: formData,
      });

      if (!response.ok) {
          throw new Error('Failed to update user data');
      }

      const updatedData = await response.json();
  } catch (error) {
      console.error('Error updating user data:', error);
      setConfirmationMessage("Failed to update profile");
  }
};


  const handleImageUpload = async () => {
    const userData = {
    };
    const fileInput = document.createElement('input');
    fileInput.type = 'file';
    fileInput.accept = 'image/*';
    fileInput.onchange = async (e) => {
      const file = e.target.files[0];
      if (file && file.type.startsWith('image/')) {
        const imageUrl = URL.createObjectURL(file);
        setProfilePicture(imageUrl);
  
        const formData = new FormData();
        formData.append("file", file);
  
        try {
          const response = await fetch(process.env.REACT_APP_API_URL + `/user/${userId}`, {
            method: 'PUT',
            headers: {
              'Authorization': `Bearer ${token}`,
            },
            body: formData,
          });
  
          if (!response.ok) {
            throw new Error('Oops! Something went wrong.');
          }
  
          const data = await response.json();
          setConfirmationMessage("Profile updated successfully");
        } catch (error) {
          console.error('Error updating user data:', error);
          setConfirmationMessage("Oops! Something went wrong.");
        }
        setShowConfirmation(true);
      }
    };
    fileInput.click();
  };

  const handleImageRemove = (event) => {
    setShowRemoveRecipeModal(false);
  };

  const handleRecipeRemove = async () => {
    setShowRemoveRecipeModal(false);

    try {
        const response = await fetch(process.env.REACT_APP_API_URL + `/recipe/${selectedRecipeId}`, {
            method: 'DELETE',
            headers: {
                'Authorization': `Bearer ${token}`
            },
        });

        if (response.ok) {
            setConfirmationMessage("Recipe removed successfully.");
            setOperationSuccess(true);
            getRecipes(); // Re-fetch recipes
        } else {
            const errorData = await response.text();
            throw new Error(`Failed to remove recipe: ${errorData}`);
        }
    } catch (error) {
        console.error('Error removing recipe:', error);
        setConfirmationMessage(error.toString());
        setOperationSuccess(false);
    }
    setShowConfirmation(true);
};

  const handleImageRemoveQuestion = (event) => {
    setRemoveQuestion(true);
  };

  const ImageRemoveQuestionClose = (event) => {
    setRemoveQuestion(false)
  };

  const handleConfirmationClose = () => {
    setShowConfirmation(false);
  };

  const getRecipes = () => {
    fetch(process.env.REACT_APP_API_URL + `/recipe/user/${userName}`, {
      headers: {
        'Authorization': `Bearer ${token}`, 
      },
    })
    .then((response) => response.json())
    .then((data) => {
      setRecipes(data);
    })
    .catch((error) => console.error("Error al obtener recetas:", error));
  }

  const onUsernameChange = (e) => {
    const value = e.target.value;
    setUserNameAux(value);
    setUsernameValid(isUsernameValid(value)); 
    setUsernameValidated(true);
    console.error(usernameValid==true)
    console.error("hola")
  };
  
  const onEmailChange = (e) => {
    const value = e.target.value;
    setUserMailAux(value);
    setEmailValid(isEmailValid(value)); 
    setEmailValidated(true);
  };
  

  const isUsernameValid = (username = "") => {
    let isValid = true; 
  
    if (username.length === 0) {
      setUsernameValidationMessage("This field is required");
      isValid = false;
    } else if (username.search(/[ !@#$%^&*(),.?":{}|<>]/) >= 0) {
      setUsernameValidationMessage(
        "Username can only contain letters, numbers, and underscores"
      );
      isValid = false;
    } else if (username.length < 4 || username.length > 20) {
      setUsernameValidationMessage(
        "Username must be between 4 and 20 characters"
      ); 
      isValid = false;
    } else {
      isUsernameAvailable(username);
    }
    setUsernameValid(isValid);
    setUsernameValidated(true);
    return isValid;
  };

  const isEmailValid = (email = "") => {
    let isValid = true;
  
    if (email.length === 0) {
      setEmailValidationMessage("This field is required");
      isValid = false;
    } else if (email.search(/^[^\s@]+@[^\s@]+\.[^\s@]+$/) < 0) {
      setEmailValidationMessage("Please enter a valid email address");
      isValid = false;
    } else {
      isEmailAvailable(email);
    }
    setEmailValid(isValid);
    setEmailValidated(true);
    return isValid;
  };

  const isUsernameAvailable = async (username = "") => {
    if (!isDoingRequest) {
      setIsDoingRequest(true);
      try {
        const response = await fetch(
          process.env.REACT_APP_API_URL + "/user/check_username/".concat(username),
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        if (!response.ok) {
          const data = await response.json();
          if (data && data.detail) {
            setUsernameValidationMessage(data.detail);
          } else {
            setUsernameValidationMessage(
              "Could not check if username is available. Please try again later."
            );
          }
        } else {
          const data = await response.json();
          setUsernameValidationMessage(data.message);
          setUsernameValid(data.status);
        }
      } catch (error) {
        setUsernameValidationMessage(
          "Could not check if username is available. Please try again later."
        );
      } finally {
        setIsDoingRequest(false);
      }
    }
  };

  const isEmailAvailable = async (email = "") => {
    if (!isDoingRequest) {
      setIsDoingRequest(true);
      try {
        const response = await fetch(process.env.REACT_APP_API_URL + "/user/check_email/".concat(email),
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
            },
          }
        );
        if (!response.ok) {
          const data = await response.json();
          if (data && data.detail) {
            setEmailValidationMessage(data.detail);
          } else {
            setEmailValidationMessage(
              "Could not check if email is available. Please try again later."
            );
          }
        } else {
          const data = await response.json();
          setEmailValidationMessage(data.message);
          setEmailValid(data.status);
        }
      } catch (error) {
        setEmailValidationMessage(
          "Could not check if email is available. Please try again later."
        );
      } finally {
        setIsDoingRequest(false);
      }
    }
  };

  const handleShowFollowersModal = () => setShowFollowersModal(true);
  const handleCloseFollowersModal = () => setShowFollowersModal(false);
  const handleShowFollowingModal = () => setShowFollowingModal(true);
  const handleCloseFollowingModal = () => setShowFollowingModal(false);

  useEffect(() => {
    setIsFollowing(userFollowers.includes(myUserName));
  }, [userFollowers]);

  const checkIfFollowed = (username) => {
    return userFollowing.includes(username);
  };

  const handleFollowUnfollow = async (username, isCurrentlyFollowed) => {
    const url = process.env.REACT_APP_API_URL + `/user/${isCurrentlyFollowed ? 'unfollow' : 'follow'}/${username}`;
    const method = 'POST';
  
    try {
      const response = await fetch(url, {
        method,
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
  
      if (!response.ok) {
        throw new Error(`Failed to ${isCurrentlyFollowed ? 'unfollow' : 'follow'} user`);
      }
  
      setMyFollowing(prevFollowing => {
        return isCurrentlyFollowed 
          ? prevFollowing.filter(user => user !== username) 
          : [...prevFollowing, username];
      });

      if(myUserName===userName){
        setUserFollowing(prevFollowing => {
          return isCurrentlyFollowed 
            ? prevFollowing.filter(user => user !== username) 
            : [...prevFollowing, username];
        })
      }
    } catch (error) {
      console.error('Error:', error);
    }
  };
  
  

  const handleFollow = async () => {
    if (token==null) {
      setShowLoginRedirectModal(true);
      return;
    }

    try {
      const response = await fetch(process.env.REACT_APP_API_URL + `/user/follow/${userName}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
  
      if (response.ok) {
        setConfirmationMessage("You are now following the user.");
        setUserFollowers(prevFollowers => [...prevFollowers, myUserName]);
      } else {
        throw new Error('There was an error following the user.');
      }
    } catch (error) {
      console.error('Error following user:', error);
      setConfirmationMessage(error.toString());
      setShowConfirmation(true);
    }
  };
  
  const handleUnfollow = async () => {
    try {
      const response = await fetch(process.env.REACT_APP_API_URL + `/user/unfollow/${userName}`, {
        method: 'POST',
        headers: {
          'Authorization': `Bearer ${token}`,
          'Content-Type': 'application/json'
        },
      });
  
      if (response.ok) {
        setConfirmationMessage("You have unfollowed the user.");
        setUserFollowers(prevFollowers => prevFollowers.filter(name => name !== myUserName));
      } else {
        throw new Error('There was an error unfollowing the user.');
      }
    } catch (error) {
      console.error('Error unfollowing user:', error);
      setConfirmationMessage(error.toString());
      setShowConfirmation(true);
    }
    setShowUnfollowModal(false);
  };
  
  return (
    <div>
        <Container>
          {}
          <Row>
            <Col sm={2}></Col>
            <Col sm={8} className="form-container mt-5 pt-3 pb-2 rounded shadow-sm">
              <Row>
                <Col sm={2} className="pl-1">
                <div className="image-container" 
                    style={{ position: 'relative' }}
                    onMouseEnter={() => setShowDropdown(true)}
                    onMouseLeave={() => setShowDropdown(false)}>
                    <Image 
                      src={profilePicture ? profilePicture : defaultProfile} 
                      alt="Profile" 
                      fluid 
                      roundedCircle 
                      style={{ 
                        width: '100px',  
                        height: '100px', 
                        objectFit: 'cover', 
                        borderRadius: '50%' 
                      }}
                    />
                  {showDropdown && adminMode && (
                    <Dropdown align="end" as={Button} variant="light" size="sm" className="edit-button" style={{ position: 'absolute', top: 0, right: 0 }} onClick={handleImageUpload}>
                        <Pencil/>
                    </Dropdown>
                  )}
                </div>
                </Col>
                <Col sm={10}>
                <Row>
                  <Col sm={6}>
                    <h3 style={profileTextStyle}>@{userName}</h3>
                  </Col>
                  <Col sm={3}></Col>
                  <Col sm={2}></Col>
                  <Col sm={1} className="d-flex justify-content-end">
                    {adminMode && (
                      <Button variant="clear" onClick={handleEditToggle}>
                        <GearFill /> {/* Usando el ícono de engranaje */}
                      </Button>
                    )}
                  </Col>
                      <div style={bioBoxStyle}>{userBio}</div>
                </Row>
                <Col sm={5} className="d-flex justify-content-around align-items-center rounded-3 p-2 mb-2"
                    style={{ backgroundColor: '#ffffff' }}>
                    
                    {/* Followers Section */}
                    <div className={`text-center hover-effect ${userIsPrivate && !adminMode ? 'disabled-element' : ''}`} onClick={userIsPrivate && !adminMode ? null : handleShowFollowersModal}>
                      <p className="small text-muted mb-1">Followers</p>
                      <p className="mb-0">{userFollowers.length}</p>
                    </div>

                    {/* Vertical Divider */}
                    <div style={{ borderLeft: '1px solid #dee2e6', height: '30px', alignSelf: 'center' }}></div>

                    {/* Following Section */}
                    <div className={`text-center hover-effect ${userIsPrivate && !adminMode ? 'disabled-element' : ''}`} onClick={userIsPrivate && !adminMode ? null : handleShowFollowingModal}>
                      <p className="small text-muted mb-1">Following</p>
                      <p className="mb-0">{userFollowing.length}</p>
                    </div>
                </Col>

                <Row className="mt-2 justify-content-center">
                  <Col sm={8}></Col>
                </Row>
                <Row className="mt-1">
                          </Row>
                          <Row>
                          <Col sm={4}>
                            {!adminMode && (
                              <Button
                                variant={isFollowing ? 'info' : 'primary'}
                                onClick={isFollowing ? () => setShowUnfollowModal(true) : handleFollow}
                                className="mb-3"
                              >
                                {isFollowing ? 'Following' : 'Follow'}
                              </Button>
                            )}
                          </Col>
                      </Row>
                </Col>
            </Row>
            <Row>
            {!userIsPrivate || adminMode ? 
              (
                recipes && recipes.length > 0 ? (
                  recipes.map((recipe) => (
                    <Col sm={12} md={6} xl={4} key={recipe._id}>
                      <CSSTransition in={true} timeout={500} classNames="slideUp" appear>
                        <Card className="mt-5 shadow" id="recipes-list">
                          <Link key={recipe._id} to={`/RecipeDetail/${recipe._id}`} className="text-decoration-none">
                            <Card.Img className="object-fit-cover" variant="top" src={recipe.main_image} alt={recipe.name} height={100}/>
                          </Link>
                          <Card.Body>
                            <Card.Title className="overflow-hidden text-nowrap">{recipe.name}</Card.Title>
                            <h5>
                              <Image src={chefIcon} style={{height: '24px', width: '24px'}} fluid/> 
                              {Array(recipe.difficulty || 0).fill().map((_, index) => (
                                <span key={index} className="fs-5 ms-1 text-center"><StarFill style={{color: 'gold'}}></StarFill></span>
                              ))}
                            </h5>
                            {adminMode && (
                              <div className="card-buttons">
                                <Button variant="outline-primary" size="sm" className="me-2" onClick={() => {
                                    setSelectedRecipeId(recipe._id)
                                    setShowEditRecipe(true)
                                }}>
                                    <Pencil />
                                </Button>
                                <Button variant="outline-danger" size="sm" onClick={() => {
                                    setSelectedRecipeId(recipe._id)
                                    setShowRemoveRecipeModal(true)
                                }}>
                                    <X />
                                </Button>
                              </div>
                            )}
                          </Card.Body>
                        </Card>
                      </CSSTransition>
                    </Col>
                  ))
                ) : ( 
                  <div className="alert alert-warning" role="alert">There are currently no Recipes</div> 
                )
              ) : (
                <div className="alert alert-warning" role="alert">The user has a private profile. You cannot see his recipes.</div> 
              )
            }


          </Row>
          <Row className="my-2"> 
            {}
          </Row>

            </Col>
            <Col sm={2}></Col>
          </Row>
        </Container>

      <Modal show={showRemoveRecipeModal} size="sm" onHide={() => setShowRemoveRecipeModal(false)}>
        <Modal.Header closeButton className="bg-normal">
          <Modal.Title>Remove recipe</Modal.Title>
        </Modal.Header>
        <Modal.Body className="bg-lightest">
          <Row>
            <Col className="text-center mb-4">
              <ExclamationTriangleFill className="text-warning" size={100} />
            </Col>
          </Row>
          <Row>
            <Col className="text-center">
              <p className="ms-0">Are you sure you want to remove this recipe?</p>
            </Col>
          </Row>
        </Modal.Body>
        <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}} className="justify-content-center">
        <Button variant="danger" onClick={handleRecipeRemove}>
          Remove
        </Button>
        </Modal.Footer>
      </Modal>

      <Modal
        show={showConfirmation}
        onHide={handleConfirmationClose}
      >
        <Modal.Header closeButton className="bg-normal">
          <Modal.Title>Profile Update</Modal.Title>
        </Modal.Header>
        <Modal.Body className="bg-lightest">{confirmationMessage}</Modal.Body>
        <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
          <Button variant="secondary" onClick={handleConfirmationClose}>
            Close
          </Button>
        </Modal.Footer>
      </Modal>

      <Modal show={showConfirmation} onHide={handleConfirmationClose}>
        <Modal.Header closeButton className="bg-normal">
            <Modal.Title>{operationSuccess ? 'Success' : 'Error'}</Modal.Title>
        </Modal.Header>
        <Modal.Body className="bg-lightest">{confirmationMessage}</Modal.Body>
        <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
            <Button variant="secondary" onClick={handleConfirmationClose}>
                Close
            </Button>
        </Modal.Footer>
    </Modal>

    <Modal show={showFollowersModal} onHide={handleCloseFollowersModal}>
      <Modal.Header closeButton className="bg-normal">
        <Modal.Title>
          Followers
        </Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-lightest">
        {followerDetails.length > 0 ? (
          followerDetails.map((follower, index) => (
            <CSSTransition in={true} timeout={500} classNames="slideUp" appear key={index}>
              <Card className="mb-0 shadow" id="followers-list" style={{ cursor: 'pointer' }} onClick={() => handleNavigate(follower._id)}>
                <Card.Body>
                  <Row>
                    <Col sm={2}>
                      <Image 
                        src={follower.profile_picture ? follower.profile_picture : defaultProfile} 
                        roundedCircle 
                        style={{ width: '30px', marginRight: '10px' }} 
                      />
                    </Col>
                    <Col sm={6}>
                      <Card.Title style={{ cursor: 'pointer' }}>{follower.username}</Card.Title>
                    </Col>
                    <Col sm={2}>
                    {(token !== null) && (follower.username !== myUserName) && (
                      <Button
                        variant={isFollowed(follower) ? 'info' : 'primary'}
                        onClick={(e) => {
                          handleFollowUnfollow(follower.username, isFollowed(follower));
                          e.stopPropagation();
                        }}
                      >
                        {isFollowed(follower) ? 'Following' : 'Follow'}
                      </Button>
                    )}

                    </Col>
                  </Row>
                </Card.Body>
              </Card>
            </CSSTransition>
          ))
        ) : (
          <p>There are no users to display.</p>
        )}
      </Modal.Body>
    </Modal>


    <Modal show={showFollowingModal} onHide={handleCloseFollowingModal}>
      <Modal.Header closeButton className="bg-normal">
        <Modal.Title>Following</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-lightest">
        {userFollowing.length > 0 ? (
        followingDetails.map((following, index) => (
          <CSSTransition in={true} timeout={500} classNames="slideUp" appear key={index}>
              <Card className="mb-0 shadow" id="followers-list" style={{ cursor: 'pointer' }} onClick={() => handleNavigate(following._id)}>
                <Card.Body>
                <Row>
                    <Col sm={2}>
                      <Image 
                        src={following.profile_picture ? following.profile_picture : defaultProfile} 
                        roundedCircle 
                        style={{ width: '30px', marginRight: '10px' }} 
                      />
                    </Col>
                    <Col sm={6}>
                      <Card.Title style={{ cursor: 'pointer' }}>{following.username}</Card.Title>
                    </Col>
                    <Col sm={2}>
                    {(token !== null) && (following.username !== myUserName) && (
                      <Button
                        variant={isFollowed(following) ? 'info' : 'primary'}
                        onClick={(e) => {
                          handleFollowUnfollow(following.username, isFollowed(following));
                          e.stopPropagation();
                        }}
                      >
                        {isFollowed(following) ? 'Following' : 'Follow'}
                      </Button>
                    )}
                    </Col>
                  </Row>
                </Card.Body>
              </Card>
            </CSSTransition>
        ))
      ) : (
        adminMode ? (
          <>
            <p>You're not following anyone. Discover creators that match your taste!</p>
            {suggestedUsers.length > 0 ? (
              suggestedUsers.slice(0, 5).map((user, index) => (
                <CSSTransition in={true} timeout={500} classNames="slideUp" appear key={index}>
                  <Card className="mb-0 shadow" id="followers-list" style={{ cursor: 'pointer' }} onClick={() => handleNavigate(user._id)}>
                    <Card.Body>
                      <Row>
                        <Col sm={2}>
                          <Image 
                            src={user.profile_picture ? user.profile_picture : defaultProfile} 
                            roundedCircle 
                            style={{ width: '30px', marginRight: '10px' }} 
                          />
                        </Col>
                        <Col>
                          <Card.Title style={{ cursor: 'pointer' }}>{user.username}</Card.Title>
                        </Col>
                      </Row>
                    </Card.Body>
                  </Card>
                </CSSTransition>
              ))
            ) : (
              <p>Loading...</p> 
            )}

          </>
        ) : (
          <p>You are not following anyone yet.</p>
        )
      )}
      </Modal.Body>
    </Modal>

    <Modal show={showUnfollowModal} onHide={() => setShowUnfollowModal(false)}>
      <Modal.Header closeButton className="fw-bold bg-normal">
        <Modal.Title>Unfollow User</Modal.Title>
      </Modal.Header>
      <Modal.Body className="bg-lightest">Do you want to unfollow this user?</Modal.Body>
      <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
        <Button variant="secondary" onClick={() => setShowUnfollowModal(false)}>
          Cancel
        </Button>
        <Button variant="danger" onClick={handleUnfollow}>
          Unfollow
        </Button>
      </Modal.Footer>
    </Modal>

    <Modal show={showLoginRedirectModal} onHide={() => setShowLoginRedirectModal(false)}>
      <Modal.Header closeButton>
        <Modal.Title>Required log in</Modal.Title>
      </Modal.Header>
      <Modal.Body>You need to log in to follow this user.</Modal.Body>
      <Modal.Footer style={{ backgroundColor: "#ffe7dfe0"}}>
        <Button variant="secondary" onClick={() => setShowLoginRedirectModal(false)}>
          Cancel
        </Button>
        <Button variant="primary" onClick={() => navigate("/login")}>
          Log in
        </Button>
      </Modal.Footer>
    </Modal>

    <Modal show={editMode} size="lg" onHide={handleClosePrivacySettings}>
        <Modal.Header closeButton className="bg-normal">
          <Modal.Title className="fs-3 fw-semi-bold">Profile Settings</Modal.Title>
        </Modal.Header>
        <Modal.Body className="p-0">
          <PrivacySettings
            onClose={handleClosePrivacySettings}
            handleSaveProfile={handleSaveProfile}
            handleVisibilityChange={handleVisibilityChange}
            imPrivate={imPrivate}
            usernameValidationMessage={usernameValidationMessage}
            emailValidationMessage={emailValidationMessage}
            userNameAux={userNameAux}
            userMailAux={userMailAux}
            userBioAux={userBioAux}
            usernameValid={usernameValid}
            usernameValidated={usernameValidated}
            emailValidated={emailValidated}
            emailValid={emailValid}
            onUsernameChange={onUsernameChange}
            onEmailChange={onEmailChange}
            setUserBioAux = {setUserBioAux}
          ></PrivacySettings>
        </Modal.Body>
    </Modal>

    <Modal
        show={showEditRecipe}
        size="lg"
        onHide={handleCloseEditRecipeModal}
      >
        <Modal.Header closeButton className="bg-normal">
          <Modal.Title className="fs-3 fw-semi-bold">Edit Recipe</Modal.Title>
        </Modal.Header>
        <Modal.Body className="p-0">
          <PostRecipe
            onClose={handleCloseEditRecipeSuccessfulModal}
            edit={true}
            id={selectedRecipeId}
          ></PostRecipe>
        </Modal.Body>
      </Modal>


    </div>
  );
};

export default UserProfile;
