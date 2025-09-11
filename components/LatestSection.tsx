import { allReviews } from '@/lib/data';
import ArticleCard from './ArticleCard';
import { Review } from '@/lib/data';

// Helper function to find the featured and latest articles from the main review list
const getLatestArticles = () => {
  // Let's define the first review as our featured one for this example
  const featuredArticle: Review | undefined = allReviews[0];
  
  // The next 3 reviews will be our "latest" list
  const latestArticles: Review[] = allReviews.slice(1, 4);

  return { featuredArticle, latestArticles };
};

const LatestSection = () => {
  const { featuredArticle, latestArticles } = getLatestArticles();

  if (!featuredArticle) {
    return null; // Don't render the section if there's no data
  }

  return (
    <section id="latest" className="section" aria-labelledby="latest-title">
      <div className="container">
        <h2 id="latest-title" className="section-title">The Latest</h2>
        <div className="latest-grid">
          <div className="featured-article">
            <ArticleCard article={featuredArticle} />
          </div>
          <div className="latest-list">
            {latestArticles.map(article => <ArticleCard key={article.id} article={article} />)}
          </div>
        </div>
      </div>
    </section>
  );
};

export default LatestSection;
