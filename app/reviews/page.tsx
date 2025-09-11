// app/reviews/page.tsx
import { allReviews } from '@/lib/data';
import ArticleCard from '@/components/ArticleCard'; // Make sure you've created this component file

export default function ReviewsPage() {
    return (
        <div className="container page-container">
            <h1 className="page-title">All Reviews</h1>
            <div className="content-grid">
                {allReviews.map(review => <ArticleCard key={review.id} article={review} />)}
            </div>
        </div>
    );
}