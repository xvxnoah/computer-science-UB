import { useState } from "react";
import { Star, StarFill } from "react-bootstrap-icons";

function StarSelector({ onSelect, maxValue, value, starSize, type }) {
  const [hoveredStar, setHoveredStar] = useState({
    value: 0,
    active: false,
  });
  let stars = [];
  for (let i = 1; i <= maxValue; i++) {
    const isActive = i <= value;
    const isHovered = i <= hoveredStar.value && hoveredStar.active;
    const aboveHovered = i > hoveredStar.value && hoveredStar.active;
    stars.push(
      <span
        key={i}
        className={""
          .concat(type)
          .concat("-star ")
          .concat(isActive ? "active" : "inactive")
          .concat(isHovered ? ((isActive && i === hoveredStar.value && i === value) ? " above-hovered" : " hovered") : "")
          .concat(aboveHovered ? " above-hovered" : "")
          .concat(" ms-2 fs-")
          .concat(7 - starSize)}
        role="button"
        onClick={() => {
          onSelect((isActive && i === value ? i - 1 : i));
        }}
        onMouseEnter={() => setHoveredStar({ value: i, active: true })}
        onMouseLeave={() => setHoveredStar({ value: 0, active: false })}
      >
        {isActive || isHovered ? <StarFill /> : <Star />}
      </span>
    );
  }
  return stars;
}

export default StarSelector;
