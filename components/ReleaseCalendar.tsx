'use client';

import { useState, useMemo } from 'react';
import { GameRelease } from '@/lib/data';
import Image from 'next/image';
import Link from 'next/link';

type ReleaseCalendarProps = {
  releases: GameRelease[];
};

const platforms: GameRelease['platforms'][0][] = ['PC', 'PS5', 'Xbox', 'Switch'];

const PlatformIcon = ({ platform }: { platform: string }) => {
    // In a real app, these would be proper icons
    const platformColors: { [key: string]: string } = {
        PC: '#9ca3af',
        PS5: '#0070d1',
        Xbox: '#107c10',
        Switch: '#e60012'
    };
    return <span style={{ 
        display: 'inline-block',
        width: '10px',
        height: '10px',
        borderRadius: '50%',
        backgroundColor: platformColors[platform] || '#ccc',
        marginRight: '6px',
        border: '1px solid var(--bg-primary)'
    }} title={platform}></span>
}

export default function ReleaseCalendar({ releases }: ReleaseCalendarProps) {
  const [activePlatforms, setActivePlatforms] = useState<string[]>([]);
  const [activeMonth, setActiveMonth] = useState<number | null>(null);

  const availableMonths = useMemo(() => {
    const months = new Set<string>();
    releases.forEach(release => {
        const month = new Date(release.releaseDate).toLocaleString('default', { month: 'long', year: 'numeric' });
        const monthKey = `${new Date(release.releaseDate).getFullYear()}-${new Date(release.releaseDate).getMonth()}`;
        months.add(JSON.stringify({label: month, key: new Date(release.releaseDate).getMonth()}));
    });
    return Array.from(months).map(m => JSON.parse(m)).filter((m, i, self) => i === self.findIndex(t => t.key === m.key));
  }, [releases]);

  const filteredReleases = useMemo(() => {
    return releases.filter(release => {
      const releaseMonth = new Date(release.releaseDate).getMonth();
      const platformMatch = activePlatforms.length === 0 || activePlatforms.some(p => release.platforms.includes(p as any));
      const monthMatch = activeMonth === null || releaseMonth === activeMonth;
      return platformMatch && monthMatch;
    });
  }, [releases, activePlatforms, activeMonth]);

  const groupedReleases = useMemo(() => {
    return filteredReleases.reduce((acc, release) => {
        const monthYear = new Date(release.releaseDate).toLocaleString('default', { month: 'long', year: 'numeric' });
        if (!acc[monthYear]) {
            acc[monthYear] = [];
        }
        acc[monthYear].push(release);
        return acc;
    }, {} as Record<string, GameRelease[]>);
  }, [filteredReleases]);

  const togglePlatform = (platform: string) => {
    setActivePlatforms(prev =>
      prev.includes(platform) ? prev.filter(p => p !== platform) : [...prev, platform]
    );
  };

  const selectMonth = (monthKey: number | null) => {
    setActiveMonth(prev => prev === monthKey ? null : monthKey);
  }

  return (
    <div>
        <div className="release-filters">
            <div className="filter-group">
                {platforms.map(p => (
                    <button key={p} onClick={() => togglePlatform(p)} className={`filter-button ${activePlatforms.includes(p) ? 'active' : ''}`}>
                        {p}
                    </button>
                ))}
            </div>
            <div className="filter-group">
                {availableMonths.map(m => (
                    <button key={m.key} onClick={() => selectMonth(m.key)} className={`filter-button ${activeMonth === m.key ? 'active' : ''}`}>
                        {m.label.split(' ')[0]}
                    </button>
                ))}
            </div>
        </div>

        <div className="release-timeline">
            {Object.keys(groupedReleases).length > 0 ? (
                Object.entries(groupedReleases).map(([monthYear, releasesInMonth]) => (
                    <div key={monthYear} className="timeline-month-section">
                        <h2 className="timeline-month-title">{monthYear}</h2>
                        <div className="timeline-games-grid">
                            {releasesInMonth.map(release => (
                                <Link key={release.id} href={`/games/${release.slug}`} className="release-card no-underline">
                                    <div className="release-card-image-container">
                                        <Image src={release.imageUrl} alt={release.title} fill style={{ objectFit: 'cover' }} className="release-card-image" />
            placeholder="blur" 
            blurDataURL={release.blurDataURL}
                                        <div className="release-card-date">
                                            {new Date(release.releaseDate).toLocaleDateString('en-US', { day: '2-digit', month: 'short' })}
                                        </div>
                                    </div>
                                    <div className="release-card-content">
                                        <h4>{release.title}</h4>
                                        <div className="release-card-platforms">
                                            {release.platforms.map(p => <PlatformIcon key={p} platform={p} />)}
                                        </div>
                                    </div>
                                </Link>
                            ))}
                        </div>
                    </div>
                ))
            ) : (
                <p style={{ textAlign: 'center', padding: '5rem 0', color: 'var(--text-secondary)' }}>No releases match your current filters.</p>
            )}
        </div>
    </div>
  );
}
