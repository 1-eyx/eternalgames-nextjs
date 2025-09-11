import { allContent } from '@/lib/data';
import { notFound } from 'next/navigation';
import ArticleCard from '@/components/ArticleCard';
import { Review, RetroArticle, NewsItem } from '@/lib/data';

type AuthorPageProps = { params: { slug: string; }; };

const isReview = (item: any): item is Review => item.type === 'review';
const isRetroArticle = (item: any): item is RetroArticle => item.type === 'archive';

export default function AuthorPage({ params }: AuthorPageProps) {
  const authorSlug = decodeURIComponent(params.slug);
  const authorContent = allContent.filter(item => 
    'author' in item && item.author?.toLowerCase().replace(' ', '-') === authorSlug
  );

  if (authorContent.length === 0) {
    notFound();
  }

  const authorName = authorContent[0].author;

  return (
    <div className="container page-container">
      <div className="author-header">
        {/* In a real app, you'd have an author image here */}
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
        {authorContent.map(item => {
            if (isReview(item) || isRetroArticle(item)) {
                return <ArticleCard key={`${item.type}-${item.id}`} article={item} isRetro={isRetroArticle(item)} />;
            }
            return null; // We'll only show reviews and articles on author pages for now
        })}
      </div>
    </div>
  );
}