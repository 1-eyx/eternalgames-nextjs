import Link from 'next/link';
import Image from 'next/image';
import { Review, RetroArticle } from '@/lib/data';
import TagLinks from './TagLinks';

type ArticleCardProps = {
  article: Review | RetroArticle;
  isRetro?: boolean;
};

const ArticleCard = ({ article, isRetro = false }: ArticleCardProps) => {
  const isReview = 'score' in article;
  const linkPath = isReview ? `/reviews/${article.slug}` : `/articles/${article.slug}`;
  
  return (
    // The outer element is now a div, NOT a Link
    <div className={`article-card ${isRetro ? 'retro-card' : ''}`}>
      <Link href={linkPath} className="no-underline card-image-link">
        <div className="card-image-container">
          {isReview && article.score && (
            <div className="card-score">{article.score.toFixed(1)}</div>
          )}
          <Image
            src={article.imageUrl}
            alt={article.title}
            fill
            sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
            style={{ objectFit: 'cover' }}
            className="card-image"
            placeholder="blur" 
            blurDataURL={article.blurDataURL}
          />
        </div>
      </Link>
      <div className="card-content">
        <div>
          <Link href={linkPath} className="no-underline">
            <h3 className="card-title-link">{article.title}</h3>
          </Link>
          <p className="card-metadata">
            {isRetro && 'year' in article ? `Released: ${article.year}` : ''}
            {isReview && 'author' in article ? (
              <Link href={`/authors/${article.author.toLowerCase().replace(' ', '-')}`} className="author-link-card no-underline">
                {article.author}
              </Link>
            ) : null}
            {isReview && ` • ${article.date}`}
          </p>
        </div>
        {/* TagLinks are now a sibling, not a descendant of another link */}
        <TagLinks tags={article.tags} small />
      </div>
    </div>
  );
};

export default ArticleCard;