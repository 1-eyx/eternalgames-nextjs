import React from 'react';

const FeaturedReviewSection = () => (
  <section id="featured-review" className="featured-review" aria-labelledby="featured-review-title">
    <h2 id="featured-review-title" className="sr-only">Featured Review</h2>
    <div className="featured-review-content">
      {/* CORRECTED: Escaped quotes */}
      <p className="review-quote">&quot;An unparalleled achievement in world-building and narrative design that will be studied for decades.&quot;</p>
      <div className="review-score-container">
        {/* CORRECTED: Escaped apostrophe */}
        <span className="review-game-title">Aethelgard&apos;s Echo</span>
        <span className="review-score">9.8</span>
      </div>
    </div>
  </section>
);

export default FeaturedReviewSection;
