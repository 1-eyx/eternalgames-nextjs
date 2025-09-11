import { upcomingReleases } from '@/lib/data';
import ReleaseCalendar from '@/components/ReleaseCalendar';

export default function ReleasesPage() {
    // Sort releases by date to ensure they are always in chronological order
    const sortedReleases = upcomingReleases.sort((a, b) => 
        new Date(a.releaseDate).getTime() - new Date(b.releaseDate).getTime()
    );

    return (
        <div className="container page-container">
            <h1 className="page-title">Game Release Calendar</h1>
            <p className="page-subtitle" style={{ textAlign: 'center', maxWidth: '600px', margin: '-2rem auto 4rem auto', color: 'var(--text-secondary)' }}>
                Track the most anticipated upcoming game launches. Filter by platform and month to plan your next adventure.
            </p>
            <ReleaseCalendar releases={sortedReleases} />
        </div>
    );
}
