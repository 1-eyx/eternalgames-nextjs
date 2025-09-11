// components/ArchivesSection.tsx
import { retroArticles } from '@/lib/data';
import ArticleCard from './ArticleCard';

const ArchivesSection = () => (
  <section id="archives" className="section" aria-labelledby="archives-title">
    <div className="container">
      <h2 id="archives-title" className="section-title">From The Archives</h2>
      <div className="archives-carousel">
        {retroArticles.map(article => (
          <ArticleCard key={article.id} article={article} isRetro />
        ))}
      </div>
    </div>
  </section>
);

export default ArchivesSection;