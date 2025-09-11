'use client';

// CORRECTED: Removed unused 'signOut' import
import { useSession, signIn } from 'next-auth/react';
import Image from 'next/image';
import Link from 'next/link';

const UserProfile = () => {
  const { data: session, status } = useSession();

  if (status === 'loading') {
    return <div className="user-profile-loading" />;
  }

  if (session && session.user) {
    return (
      <div className="user-profile-container">
        <Link href="/profile" className="no-underline" title="View your profile">
            <Image
            src={session.user.image || ''} 
            alt={session.user.name || 'User Avatar'}
            width={36}
            height={36}
            className="user-avatar"
            />
        </Link>
      </div>
    );
  }

  return (
    <button onClick={() => signIn('github')} className="auth-button signin">
      Sign In
    </button>
  );
};

export default UserProfile;
