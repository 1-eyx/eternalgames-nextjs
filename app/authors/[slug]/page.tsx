import { allReviews } from '@/lib/data'; // CORRECTED: We only need to check reviews
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review } from '@/lib/data';

type AuthorPageProps = { params: { slug: string; }; };

// This logic is now much simpler and safer
const isReview = (item: Review): item is Review => item.type === 'review';

export default function AuthorPage({ params }: AuthorPageProps) {
  const authorSlug = decodeURIComponent(params.slug);
  
  // CORRECTED: We filter from 'allReviews', which is a typed array of Review[].
  // This guarantees every item has an 'author' property.
  const authorContent = allReviews.filter(item => 
    item.author.toLowerCase().replace(' ', '-') === authorSlug
  );

  if (authorContent.length === 0) {
    notFound();
  }

  // This line is now 100% type-safe.
  const authorName = authorContent[0].author;

  return (
    <div className="container page-container">
      <div className="author-header">
        <div className="author-avatar-placeholder">
          {authorName?.charAt(0)}
        </div>
        <h1 className="page-title">{authorName}</h1>
        <p className="author-bio">
          {authorName} is a veteran writer at EternalGames, specializing in deep-dive reviews and cultural analysis of the gaming world.
        </p>
      </div>

      <h2 className="section-title" style={{ marginTop: '5rem' }}>Articles by {authorName}</h2>
      <div className="content-grid">
        {/* CORRECTED: The mapping logic is now simpler as we know everything is a review. */}
        {authorContent.map(item => {
            if (isReview(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} />;
            }
            return null;
        })}
      </div>
    </div>
  );
}
