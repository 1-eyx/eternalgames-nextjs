// I've added a set of pre-generated blur hashes to use in the mock data.
const BLUR_HASHES = {
  scifi: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAECAYAAACzzX7wAAAAAXNSR0IArs4c6QAAACNJREFUGFdjePLkKY4cObIcS0/P/I+SkpL/l5SUNGVmZkZgYAAAN2YQe9s0G6YAAAAASUVORK5CYII=',
  fantasy: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAECAYAAACzzX7wAAAAAXNSR0IArs4c6QAAACVJREFUGFdjdPbvP5//+/fv/z9s2LAtYGJgYPhPfv784d27d5sYGBgAAPk0Dk9B1FpGAAAAAElFTSuQmCC',
  nature: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAECAYAAACzzX7wAAAAAXNSR0IArs4c6QAAACFJREFUGFdjdPDgQQoMDAw/l5fX/P/792+GjY2N4ePjYwYGBgYASg8HZRf3wK4AAAAASUVORK5CYII=',
  tech: 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAgAAAAECAYAAACzzX7wAAAAAXNSR0IArs4c6QAAACNJREFUGFdjePLkKY5ERES+y8rK/o+SkhL/l5SUNGVmZkZgYAAAz7EQk+yKEOcAAAAASUVORK5CYII=',
};

// --- TYPE DEFINITIONS ---
export type ContentBlock = 
  | { type: 'paragraph'; content: string; }
  | { type: 'image'; src: string; alt: string; blurDataURL: string; }
  | { type: 'pullquote'; content: string; };

// CORRECTED: Added the 'type' property to the blueprint itself.
export type Review = {
  type: 'review';
  id: number; slug: string; game: string; title: string; author: string; date: string; 
  imageUrl: string; score: number; verdict: string; pros: string[]; cons: string[];
  tags: string[]; content: ContentBlock[]; relatedReviewIds: number[];
  blurDataURL: string;
};

// CORRECTED: Added the 'type' property.
export type RetroArticle = {
  type: 'archive';
  id: number; slug: string; game: string; title: string; year: number;
  imageUrl: string; tags: string[];
  blurDataURL: string;
};

// CORRECTED: Added the 'type' property.
export type NewsItem = {
    type: 'news';
    id: number; slug: string; game: string | null; title: string; 
    category: string; imageUrl: string; date: string; tags: string[];
    blurDataURL: string;
};

export type GameRelease = {
  id: number;
  slug: string;
  title: string;
  releaseDate: string; // ISO 8601 format: "YYYY-MM-DD"
  platforms: ('PC' | 'PS5' | 'Xbox' | 'Switch')[];
  imageUrl: string;
  synopsis: string;
  blurDataURL: string;
};

// --- MOCK DATA ---
export const allReviews: Review[] = [
  { type: 'review', id: 1, slug: "cybernetic-dawn-a-100-hour-descent", game: "Cyberpunk 2077", title: "Cybernetic Dawn: A 100-Hour Descent", author: "Juno Steel", date: "October 26, 2077", imageUrl: "https://images.unsplash.com/photo-1604280261394-27b5de695137?q=80&w=2070&auto=format&fit=crop", score: 9.3, verdict: "A masterpiece, making the entire package an absolute must-play.", pros: ["Gripping spy-thriller narrative", "Dogtown is a fantastic new area", "Complete overhaul of core systems"], cons: ["Can be demanding on hardware", "Some old bugs still linger"], tags: ["RPG", "Sci-Fi", "Action"], blurDataURL: BLUR_HASHES.scifi, content: [ { type: 'paragraph', content: "Night City has never felt more alive, or more dangerous. With the Phantom Liberty expansion and the groundbreaking 2.0 update, Cyberpunk 2077 has completed one of the most remarkable redemption arcs in gaming history." }, { type: 'image', src: 'https://images.unsplash.com/photo-1593429337220-91a3a8f9039a?q=80&w=2070&auto=format&fit=crop', alt: 'A futuristic car driving through a neon-lit city at night.', blurDataURL: BLUR_HASHES.scifi }, { type: 'paragraph', content: "The new district of Dogtown is a labyrinth of intrigue, and the spy-thriller narrative, anchored by a stellar performance from Idris Elba, is CD Projekt Red at its best." }, { type: 'pullquote', content: "This is the game we all dreamed of in 2020." } ], relatedReviewIds: [16, 19] },
  { type: 'review', id: 16, slug: "aethelgards-echo-a-generational-saga", game: "Aethelgard's Echo", title: "Aethelgard's Echo: A Generational Saga", author: "Elara Vance", date: "October 24, 2077", imageUrl: "https://images.unsplash.com/photo-1534972195531-d756b9bfa9f2?q=80&w=2070&auto=format&fit=crop", score: 9.8, verdict: "An unparalleled achievement in world-building and narrative design that will be studied for decades.", pros: ["Deep, emotionally resonant story", "Revolutionary procedural generation", "Gorgeous art style"], cons: ["Combat can feel slow at times"], tags: ["RPG", "Fantasy", "Strategy"], blurDataURL: BLUR_HASHES.fantasy, content: [ { type: 'paragraph', content: "Every now and then, a game arrives that doesn't just raise the bar, but creates an entirely new one. Aethelgard's Echo is that game. It's a sprawling, generational tale set in a world so rich and detailed it feels less like a creation and more like a discovery." }, ], relatedReviewIds: [1, 19] },
  { type: 'review', id: 19, slug: "the-silent-bloom-hauntingly-beautiful", game: "The Silent Bloom", title: "The Silent Bloom: A Hauntingly Beautiful Puzzle", author: "Maria Flores", date: "October 18, 2077", imageUrl: "https://images.unsplash.com/photo-1488330890490-c291ecf62571?q=80&w=2070&auto=format&fit=crop", score: 9.2, verdict: "A masterpiece of minimalist design and emotional storytelling.", pros: ["Stunning art direction", "Intelligent and rewarding puzzles", "A deeply moving, wordless narrative"], cons: ["Some puzzles can be obtuse"], tags: ["Puzzle", "Indie", "Atmospheric"], blurDataURL: BLUR_HASHES.nature, content: [ { type: 'paragraph', content: "In a world of explosive action and complex systems, The Silent Bloom is a quiet revolution. It tells its story not with words, but with light, shadow, and beautifully crafted environmental puzzles." } ], relatedReviewIds: [1, 16] }
];

export const retroArticles: RetroArticle[] = [
    { type: 'archive', id: 5, slug: 'chronicles-of-time-retrospective', game: 'Chronicles of Time', title: "Chronicles of Time: A Retrospective", year: 1995, imageUrl: "https://picsum.photos/seed/chrono/400/300", tags: ["RPG", "Classic", "JRPG"], blurDataURL: BLUR_HASHES.fantasy },
    { type: 'archive', id: 6, slug: 'super-metroid-echoes', game: 'Super Metroid', title: "Super Metroid: The Masterpiece That Still Echoes", year: 1994, imageUrl: "https://picsum.photos/seed/metroid/400/300", tags: ["Action", "Platformer", "Sci-Fi"], blurDataURL: BLUR_HASHES.scifi },
];

export const newsItems: NewsItem[] = [
    { type: 'news', id: 10, slug: 'ghibli-rpg-partnership', game: null, title: "Studio Ghibli partners with indie studio for new RPG.", category: "Industry", imageUrl: "https://images.unsplash.com/photo-1542856334-c361993335a9?q=80&w=1964&auto=format&fit=crop", date: "October 27, 2077", tags: ["RPG", "Industry"], blurDataURL: BLUR_HASHES.nature },
    { type: 'news', id: 11, slug: 'portal-vr-headset', game: null, title: "Next-gen VR headset 'Portal' to feature sensory feedback.", category: "Hardware", imageUrl: "https://images.unsplash.com/photo-1593508512255-86ab42a8e620?q=80&w=1778&auto=format&fit=crop", date: "October 27, 2077", tags: ["Hardware", "VR"], blurDataURL: BLUR_HASHES.tech },
    { type: 'news', id: 14, slug: 'starfall-online-patch-7-2', game: 'Starfall Online', title: "Patch 7.2 for 'Starfall Online' brings massive overhaul.", category: "Updates", imageUrl: "https://images.unsplash.com/photo-1570314271131-9a7445a5d290?q=80&w=2070&auto=format&fit=crop", date: "October 26, 2077", tags: ["MMO", "Sci-Fi", "Updates"], blurDataURL: BLUR_HASHES.scifi },
];

export const upcomingReleases: GameRelease[] = [
  { id: 101, slug: 'star-wanderer-odyssey', title: 'Star Wanderer: Odyssey', releaseDate: '2024-06-14', platforms: ['PC', 'PS5'], imageUrl: 'https://images.unsplash.com/photo-1534796636912-3b95b3ab5986?q=80&w=2071&auto=format&fit=crop', synopsis: 'Explore a vast, procedurally generated galaxy in this epic space opera RPG.', blurDataURL: BLUR_HASHES.scifi },
  { id: 102, slug: 'elden-ring-shadow-of-the-erdtree', title: 'Elden Ring: Shadow of the Erdtree', releaseDate: '2024-06-21', platforms: ['PC', 'PS5', 'Xbox'], imageUrl: 'https://images.unsplash.com/photo-1618035802319-58b2d1143577?q=80&w=1964&auto-format&fit=crop', synopsis: 'Journey to the Land of Shadow to uncover the dark secrets of the Erdtree.', blurDataURL: BLUR_HASHES.fantasy },
  { id: 103, slug: 'pixel-pioneers', title: 'Pixel Pioneers', releaseDate: '2024-06-28', platforms: ['PC', 'Switch'], imageUrl: 'https://images.unsplash.com/photo-1598562442795-03a421b8481e?q=80&w=2070&auto-format&fit=crop', synopsis: 'A charming farming simulator with a retro twist and deep crafting systems.', blurDataURL: BLUR_HASHES.nature },
  { id: 104, slug: 'neon-rush-2088', title: 'Neon Rush 2088', releaseDate: '2024-07-05', platforms: ['PC', 'Xbox'], imageUrl: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?q=80&w=2071&auto-format&fit=crop', synopsis: 'High-speed, anti-gravity racing through a futuristic metropolis.', blurDataURL: BLUR_HASHES.tech },
  { id: 105, slug: 'the-forgotten-kingdom', title: 'The Forgotten Kingdom', releaseDate: '2024-07-19', platforms: ['PS5'], imageUrl: 'https://images.unsplash.com/photo-1531393810484-24511d171af5?q=80&w=1974&auto=format&fit=crop', synopsis: 'Uncover the mysteries of a fallen civilization in this narrative-driven adventure.', blurDataURL: BLUR_HASHES.fantasy },
  { id: 106, slug: 'pocket-critters-world', title: 'Pocket Critters World', releaseDate: '2024-08-16', platforms: ['Switch'], imageUrl: 'https://images.unsplash.com/photo-1554941452-9f3245a47248?q=80&w=2070&auto=format&fit=crop', synopsis: 'Collect, train, and battle hundreds of cute creatures in a vibrant open world.', blurDataURL: BLUR_HASHES.nature },
  { id: 107, slug: 'ghost-of-tsushima-directors-cut-pc', title: 'Ghost of Tsushima Director\'s Cut', releaseDate: '2024-05-16', platforms: ['PC'], imageUrl: 'https://images.unsplash.com/photo-1600277221345-453344423b75?q=80&w=1932&auto-format&fit=crop', synopsis: 'The acclaimed open-world samurai adventure arrives on PC with new features.', blurDataURL: BLUR_HASHES.fantasy },
];

// Now we combine the typed data, preserving the types.
export const allContent: (Review | RetroArticle | NewsItem)[] = [
    ...allReviews,
    ...retroArticles,
    ...newsItems,
];
