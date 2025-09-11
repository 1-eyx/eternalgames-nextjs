// components/FeaturedReviewSection.tsx
import React from 'react';

const FeaturedReviewSection = () => (
  <section id="featured-review" className="featured-review" aria-labelledby="featured-review-title">
    <h2 id="featured-review-title" className="sr-only">Featured Review</h2>
    <div className="featured-review-content">
      {/* We can wrap this in an Animate component later if we build one */}
      <p className="review-quote">"An unparalleled achievement in world-building and narrative design that will be studied for decades."</p>
      <div className="review-score-container">
        <span className="review-game-title">Aethelgard's Echo</span>
        <span className="review-score">9.8</span>
      </div>
    </div>
  </section>
);

export default FeaturedReviewSection;