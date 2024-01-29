import { useState } from "react";
import {
  Container,
  Stack,
  InputGroup,
  Form,
  Offcanvas,
  Badge,
} from "react-bootstrap";
import { Funnel, FunnelFill, X, SortUp, SortDown } from "react-bootstrap-icons";

import RecipeFilters from "./RecipeFilters";
import sort_options from "../assets/jsonData/sort_options.json";
import "../css/common.css";

function RecipeBrowser({ onSearch }) {
  const keyParsing = {
    sortBy: "Sort by:",
    sortAscending: "",
    maxDifficulty: "Difficulty:",
    maxTime: "Time:",
    minRating: "Rating:",
    maxCalories: "Calories",
  };

  const valueParsing = {
    sortBy: "",
    sortAscending: "",
    maxDifficulty: " stars or less",
    maxTime: " min or less",
    minRating: " stars or more",
    maxCalories: " cal or less",
  };

  const defaultFilters = {
    sortBy: "none",
    sortAscending: false,
    maxDifficulty: 5,
    maxTime: 180,
    minRating: 0,
    maxCalories: 5000,
  };

  const [recipeName, setRecipeName] = useState("");
  const [filtersOffCanvas, setFiltersOffCanvas] = useState({
    title: "Filters",
    show: false,
    values: JSON.parse(localStorage.getItem("filters")) || defaultFilters,
  });

  const handleCloseOffcanvas = (
    setOffCanvasState,
    offCanvasState,
    applyFilters,
    filterValues
  ) => {
    setOffCanvasState({
      ...offCanvasState,
      show: false,
      values: filterValues || offCanvasState.values,
    });
    if (applyFilters) {
      onSearch(filterValues || offCanvasState.values, recipeName);
    }
  };

  return (
    <Container>
      <Container className="d-flex">
        <span
          className="fs-3 ms-auto me-3 colorless-span-button position"
          role="button"
          onClick={() => {
            setFiltersOffCanvas({ ...filtersOffCanvas, show: true });
          }}
        >
          <FunnelFill />
        </span>
        <InputGroup id="search-bar-container" className="w-25">
          <Form.Control
            className="d-flex shadow-none"
            id="search-bar"
            type="text"
            placeholder="Search..."
            value={recipeName}
            onChange={(e) => {
              setRecipeName(e.target.value);
              onSearch(filtersOffCanvas.values, e.target.value);
            }}
          />
          <InputGroup.Text className="fs-4" id="search-bar-clear">
            {recipeName.length > 0 && (
              <X
                className="colorless-span-button"
                role="button"
                onClick={() => {
                  setRecipeName("");
                  onSearch(filtersOffCanvas.values, "");
                }}
              />
            )}
          </InputGroup.Text>
        </InputGroup>
      </Container>
      <Container className="d-flex mt-4">
        {JSON.stringify(filtersOffCanvas.values) !==
          JSON.stringify(defaultFilters) && (
          <div
            className="d-flex colorless-span-button me-4"
            role="button"
            onClick={() => {
              setFiltersOffCanvas({
                ...filtersOffCanvas,
                values: defaultFilters,
              });
              localStorage.setItem("filters", JSON.stringify(defaultFilters));
              onSearch(defaultFilters, recipeName);
            }}
          >
            <X className="fs-5 mt-1" />
            <span className="mx-2">Clear filters</span>
            <Funnel className="fs-5 mt-1" />
          </div>
        )}
        <Stack direction="horizontal" gap={2}>
          {Object.entries(filtersOffCanvas.values)
            .filter(
              ([key, value]) =>
                value !== defaultFilters[key] ||
                (key === "sortAscending" &&
                  filtersOffCanvas.values.sortBy !== "none")
            )
            .map(([key, value]) => (
              <Badge pill bg="secondary">
                {keyParsing[key]}{" "}
                {key === "sortBy"
                  ? sort_options.fields.filter(
                      (option) => option.name === value
                    )[0].displayName
                  : value === true
                  ? "Ascending"
                  : value === false
                  ? "Descending"
                  : value.toString().concat(valueParsing[key])}
                {key === "sortAscending" ? (
                  <div
                    className="ms-1 d-inline-block"
                    role="button"
                    onClick={() => {
                      const newValues = { ...filtersOffCanvas.values };
                      newValues[key] = !newValues[key];
                      setFiltersOffCanvas({
                        ...filtersOffCanvas,
                        values: newValues,
                      });
                      localStorage.setItem(
                        "filters",
                        JSON.stringify(newValues)
                      );
                      onSearch(newValues, recipeName);
                    }}
                  >
                    {value ? (
                      <SortUp />
                    ) : (
                      <SortDown className="ms-1" role="button" />
                    )}
                  </div>
                ) : (
                  <X
                    className="ms-1"
                    role="button"
                    onClick={() => {
                      const newValues = { ...filtersOffCanvas.values };
                      newValues[key] = defaultFilters[key];
                      setFiltersOffCanvas({
                        ...filtersOffCanvas,
                        values: newValues,
                      });
                      localStorage.setItem(
                        "filters",
                        JSON.stringify(newValues)
                      );
                      onSearch(newValues, recipeName);
                    }}
                  />
                )}
              </Badge>
            ))}
        </Stack>
      </Container>
      <Offcanvas
        show={filtersOffCanvas.show}
        onHide={() =>
          handleCloseOffcanvas(setFiltersOffCanvas, filtersOffCanvas, false)
        }
      >
        <Offcanvas.Header closeButton className="bg-normal">
          <Offcanvas.Title className="fs-3 fw-semi-bold">
            {filtersOffCanvas.title}
          </Offcanvas.Title>
        </Offcanvas.Header>
        <Offcanvas.Body className="p-0">
          <RecipeFilters
            onClose={(filters) => {
              localStorage.setItem("filters", JSON.stringify(filters));
              handleCloseOffcanvas(
                setFiltersOffCanvas,
                filtersOffCanvas,
                true,
                filters
              );
            }}
            inValues={filtersOffCanvas.values}
          />
        </Offcanvas.Body>
      </Offcanvas>
    </Container>
  );
}

export default RecipeBrowser;
