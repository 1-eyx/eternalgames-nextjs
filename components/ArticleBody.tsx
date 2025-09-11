import React from 'react';
import Image from 'next/image';
import { ContentBlock } from '../lib/data';

type ArticleBodyProps = {
  content: ContentBlock[];
};

const ArticleBody = ({ content }: ArticleBodyProps) => {
  return (
    <div className="article-body">
      {content.map((block, index) => {
        switch (block.type) {
          case 'paragraph':
            return <p key={index}>{block.content}</p>;
          case 'image':
            return (
              <div key={index} className="article-image-wrapper">
                <Image 
                  src={block.src} 
                  alt={block.alt} 
                  width={800} 
                  height={450} 
                  style={{ width: '100%', height: 'auto', borderRadius: '8px' }}
                  placeholder="blur"                   blurDataURL={block.blurDataURL}
                />
              </div>
            );
          case 'pullquote':
            return <blockquote key={index}>{block.content}</blockquote>;
          default:
            return null;
        }
      })}
    </div>
  );
};

export default ArticleBody;