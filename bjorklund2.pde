int[] bjorklund2(int n, int k) {
  if (n==0) n=1;
  int[] result = new int[n];
  result[0]= k>0? 1:0;
  for (int x=1; x<n; x++) {
    result[x]=(k*x)/n;
    result[x]-=(k*(x-1))/n;
  }

  return result;
}
