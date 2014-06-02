/*

net/sctp/socket.c sctp_setsockopt_maxseg check 
3009 
3010         if ((val != 0) && ((val < 8) || (val > SCTP_MAX_CHUNK_LEN)))
3011                 return -EINVAL;
3012 

*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <netinet/sctp.h>
#include <arpa/inet.h>
#define MAX_BUFFER 1024

int main(int argc, char** argv) {
  int sockfd, in, i, ret, flags, maxseg;
  int port, pathmtu, frag_point;
  struct sockaddr_in servaddr;
  char buffer[MAX_BUFFER+1];
  struct sctp_paddrparams params;
  struct sockaddr_in* par_add;
  
  if (argc < 4){
    printf("usage: %s port pathmtu frag_point \n",argv[0]);
    exit(1);
  }
  
  port       = atoi(argv[1]);
  pathmtu    = atoi(argv[2]);
  frag_point = atoi(argv[3]);
  maxseg = frag_point;
  
  memset(&buffer,0x66,sizeof(buffer));
  buffer[MAX_BUFFER]=0;
  bzero(&params,sizeof(params));
  bzero(&par_add,sizeof(par_add));

  params.spp_pathmtu = pathmtu;
  params.spp_flags   = 1<<4 ;
  par_add = (struct sockaddr_in *) &params.spp_address;
  par_add->sin_addr.s_addr = htonl( INADDR_ANY );
  sockfd = socket( AF_INET, SOCK_STREAM, IPPROTO_SCTP );
  if(sockfd == -1) perror("socket()");

  bzero( (void *)&servaddr, sizeof(servaddr) );
  servaddr.sin_family = AF_INET;
  servaddr.sin_port = htons(port);
  servaddr.sin_addr.s_addr = inet_addr( "127.0.0.1" );

  printf("connecting\n");
  ret = connect( sockfd, (struct sockaddr *)&servaddr, sizeof(servaddr) );
  if(ret == -1) perror("connect()");
  
  printf("setsockopt\n");
  ret = setsockopt( sockfd, IPPROTO_SCTP, SCTP_PEER_ADDR_PARAMS, &params, sizeof(params) );
  if(ret == -1) perror("setsockopt SCTP_PEER_ADDR_PARAMS()");
  
  printf("set maxseg to %i\n",maxseg); 
  ret = setsockopt( sockfd, IPPROTO_SCTP, SCTP_MAXSEG, &maxseg, sizeof(int) );
  if(ret == -1) perror("setsockopt SCTP_MAXSEG()");
  
  //params.spp_pathmtu = frag_point;
  //ret = setsockopt( sockfd, IPPROTO_SCTP, SCTP_PEER_ADDR_PARAMS, &params, sizeof(params) );
  if(ret == -1) perror("setsockopt SCTP_PEER_ADDR_PARAMS()");
  
  printf("sendmsg\n");
  ret = sctp_sendmsg( sockfd, (void *)buffer, (size_t)sizeof(buffer), NULL, 0, 0, 0, 0, 0, 0 );
  if(ret == -1) perror("sctp_sendmsg()");
  
  close(sockfd);
  return 0;
}
