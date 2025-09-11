'use client';

import { useEffect } from 'react';
import { useUserStore } from '@/lib/store';

const LogVisit = ({ articleId }: { articleId: number }) => {
  const addVisit = useUserStore((state) => state.addVisit);

  useEffect(() => {
    addVisit(articleId);
  }, [articleId, addVisit]);

  return null;
};

export default LogVisit;
