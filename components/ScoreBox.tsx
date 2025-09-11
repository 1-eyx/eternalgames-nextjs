// components/ScoreBox.tsx
import React from 'react';
import { Review } from '@/lib/data'; // Import the Review type

type ScoreBoxProps = {
  review: Review;
};

const CheckIcon = () => (
  <svg className="pros-icon" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z" clipRule="evenodd"></path></svg>
);

const CrossIcon = () => (
  <svg className="cons-icon" fill="currentColor" viewBox="0 0 20 20"><path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd"></path></svg>
);

const ScoreBox = ({ review }: ScoreBoxProps) => {
  return (
    <div className="review-score-box">
      <div className="score-box-score">{review.score.toFixed(1)}</div>
      <div className="score-box-verdict-title">Verdict</div>
      <p className="score-box-verdict-text">{review.verdict}</p>
      <div className="score-box-divider"></div>
      <div className="score-box-pros-cons">
        <div className="pros-cons-list">
          <h4>Pros</h4>
          <ul>
            {review.pros.map((pro, index) => (
              <li key={index}><CheckIcon /> {pro}</li>
            ))}
          </ul>
        </div>
        <div className="pros-cons-list">
          <h4>Cons</h4>
          <ul>
            {review.cons.map((con, index) => (
              <li key={index}><CrossIcon /> {con}</li>
            ))}
          </ul>
        </div>
      </div>
    </div>
  );
};

export default ScoreBox;