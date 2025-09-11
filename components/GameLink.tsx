import Link from 'next/link';
import React from 'react';

type GameLinkProps = {
  gameName: string;
};

const GameLink = ({ gameName }: GameLinkProps) => {
  if (!gameName) return null;
  const slug = gameName.replace(/\s+/g, '-').toLowerCase();
  
  return (
    <Link href={`/games/${slug}`} className="game-link no-underline">
      {gameName}
    </Link>
  );
};

export default GameLink;