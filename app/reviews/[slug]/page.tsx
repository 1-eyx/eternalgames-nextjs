import { allReviews } from '@/lib/data';
import Image from 'next/image';
import ScoreBox from '@/components/ScoreBox';
import ArticleBody from '@/components/ArticleBody';
import ArticleCard from '@/components/ArticleCard';
import { notFound } from 'next/navigation';
import GameLink from '@/components/GameLink';
import BookmarkButton from '@/components/BookmarkButton';
import TagLinks from '@/components/TagLinks';
import Link from 'next/link';
import LogVisit from '@/components/LogVisit';
import GiscusComments from '@/components/GiscusComments';

type ReviewPageProps = { params: { slug: string; }; };

export default function ReviewPage({ params }: ReviewPageProps) {
  const review = allReviews.find(r => r.slug === params.slug);
  if (!review) { notFound(); }

  const relatedReviews = allReviews.filter(r => review.relatedReviewIds.includes(r.id));

  return (
    <>
      <LogVisit articleId={review.id} />
      <div className="container page-container">
        <div className="review-layout">
          <main className="review-main-content">
            <GameLink gameName={review.game} />
            <h1 className="page-title" style={{ textAlign: 'left', marginBottom: '1rem', fontSize: '4.8rem' }}>{review.title}</h1>
            <div className="review-metadata">
              <p>
                By <Link href={`/authors/${review.author.toLowerCase().replace(' ', '-')}`} className="author-link">{review.author}</Link> • {review.date}
              </p>
              <BookmarkButton articleId={review.id} />
            </div>
            <div className="review-hero-image">
              <Image src={review.imageUrl} alt={review.title} fill style={{ objectFit: 'cover' }} priority placeholder="blur" blurDataURL={review.blurDataURL} />
            </div>
            <ArticleBody content={review.content} />
            <ScoreBox review={review} />
            <TagLinks tags={review.tags} />
          </main>

          <aside className="review-sidebar">
              <div className="related-articles-section">
                  <h2 className="section-title" style={{textAlign: 'left', fontSize: '2.4rem'}}>You Might Also Like</h2>
                  <div className="related-articles-grid">
                      {relatedReviews.map(related => (<ArticleCard key={related.id} article={related} />))}
                  </div>
              </div>
          </aside>
        </div>
      </div>

      <div className="container" style={{ paddingBottom: '6rem' }}>
        <GiscusComments />
      </div>
    </>
  );
}
