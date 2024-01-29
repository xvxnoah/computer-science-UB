import { useState } from "react";
import { Container, Button, Form } from "react-bootstrap";
import { SortUp, SortDown, X, Funnel } from "react-bootstrap-icons";
import StarSelector from "./StarSelector";
import sortOptions from "../assets/jsonData/sort_options.json";

function RecipeFilters({ onClose, inValues }) {
  const defaultFilters = {
    sortBy: "none",
    sortAscending: false,
    maxDifficulty: 5,
    maxTime: 180,
    minRating: 0,
    maxCalories: 5000,
  };

  const [filters, setFilters] = useState(inValues || defaultFilters);

  return (
    <Container className="bg-lightest min-vh-100 p-4">
      {JSON.stringify(filters) !== JSON.stringify(defaultFilters) && (
        <div
          className="d-flex colorless-span-button mb-4"
          role="button"
          onClick={() => setFilters(defaultFilters)}
        >
          <X className="fs-5 mt-1" />
          <span className="mx-2">Clear filters</span>
          <Funnel className="fs-5 mt-1" />
        </div>
      )}
      <Form>
        <Form.Group>
          <Form.Label>Sort By</Form.Label>
          <div className="d-flex">
              <Form.Select 
              className="me-3" 
              value={filters.sortBy}
              onChange={(e) => {
                  setFilters({
                      ...filters,
                      sortBy: e.target.value,
                  });
              }}
          >
              {sortOptions.fields.map((option) => (
                  <option
                      key={option.id}
                      value={option.name}
                  >
                      {option.displayName}
                  </option>
              ))}
          </Form.Select>
          <span
              className="fs-4 colorless-span-button"
              role="button"
              onClick={() => {
                  setFilters({
                      ...filters,
                      sortAscending: !filters.sortAscending,
                  });
              }}
          >
              {filters.sortAscending ? <SortUp /> : <SortDown />}
          </span>
          </div>
        </Form.Group>
        <Form.Group className="mt-4">
          <Form.Label className="mb-0">Difficulty</Form.Label>
          <div>
            <StarSelector
              maxValue={5}
              value={filters.maxDifficulty}
              starSize={2}
              type={"difficulty"}
              onSelect={(value) =>
                setFilters({ ...filters, maxDifficulty: value })
              }
            />
          </div>
        </Form.Group>
        <Form.Group className="mt-4">
          <Form.Label className="mb-0">Rating</Form.Label>
          <div>
            <StarSelector
              maxValue={5}
              value={filters.minRating}
              starSize={2}
              type={"rating"}
              onSelect={(value) => setFilters({ ...filters, minRating: value })}
            />
          </div>
        </Form.Group>
        <Form.Group className="mt-4">
          <Form.Label className="mb-0">Time</Form.Label>
          <div className="position-relative">
            <Form.Range
              min={0}
              max={180}
              value={filters.maxTime}
              title={filters.maxTime + " min"}
              onChange={(e) =>
                setFilters({ ...filters, maxTime: e.target.value })
              }
            />
            <div className="position-absolute bottom-100 start-50 translate-middle-x">
              {filters.maxTime} min
            </div>
          </div>
        </Form.Group>
        <div className="d-flex justify-content-between">
          <span>0 min</span>
          <span>180 min</span>
        </div>
        <Form.Group className="mt-4">
          <Form.Label className="mb-0">Calories</Form.Label>
          <div className="position-relative">
            <Form.Range
              min={0}
              max={5000}
              value={filters.maxCalories}
              onChange={(e) =>
                setFilters({ ...filters, maxCalories: e.target.value })
              }
            />
            <div className="position-absolute bottom-100 start-50 translate-middle-x">
              {filters.maxCalories} cal
            </div>
          </div>
        </Form.Group>
        <div className="d-flex justify-content-between">
          <span>0 cal</span>
          <span>5000 cal</span>
        </div>
        <div className="d-flex justify-content-center">
          <Button
            className="positive-button border-0 mt-4"
            id="mainButton"
            onClick={() => onClose(filters)}
          >
            Apply
          </Button>
        </div>
      </Form>
    </Container>
  );
}

export default RecipeFilters;
