import { retroArticles } from '@/lib/data';
import { notFound } from 'next/navigation';
import Image from 'next/image';
import TagLinks from '@/components/TagLinks';
import LogVisit from '@/components/LogVisit';
import GiscusComments from '@/components/GiscusComments';

type ArticlePageProps = { params: { slug: string; }; };

export default function ArticlePage({ params }: ArticlePageProps) {
  const article = retroArticles.find(a => a.slug === params.slug);

  if (!article) {
    notFound();
  }

  return (
    <>
      <LogVisit articleId={article.id} />
      <div className="container page-container">
        <div style={{ maxWidth: '800px', margin: '0 auto' }}>
          <h1 className="page-title" style={{ textAlign: 'left', marginBottom: '1rem' }}>{article.title}</h1>
          <p style={{ color: 'var(--text-secondary)', marginBottom: '3rem' }}>Originally Released: {article.year}</p>
          <div className="review-hero-image">
            <Image 
                src={article.imageUrl} 
                alt={article.title} 
                fill 
                style={{ objectFit: 'cover' }} 
                priority 
                placeholder="blur" 
                blurDataURL={article.blurDataURL}
            />
          </div>
          
          <div className="article-body">
              <p>This is a placeholder for the full article content about {article.title}. In a real CMS, this would be filled with rich text, images, and other dynamic blocks, similar to the review page.</p>
          </div>
          
          <TagLinks tags={article.tags} />

        </div>
      </div>
      
      <div className="container" style={{ paddingBottom: '6rem' }}>
        <GiscusComments />
      </div>
    </>
  );
}
