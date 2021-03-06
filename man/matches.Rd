% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/grr.R
\name{matches}
\alias{matches}
\title{Value Matching}
\usage{
matches(x, y, all.x = TRUE, all.y = TRUE, list = FALSE, indexes = TRUE,
  nomatch = NA)
}
\arguments{
\item{x}{vector.  The values to be matched.  Long vectors are not currently supported.}

\item{y}{vector.  The values to be matched.  Long vectors are not currently supported.}

\item{all.x}{logical; if \code{TRUE}, then each value in \code{x} will be included
even if it has no matching values in \code{y}}

\item{all.y}{logical; if \code{TRUE}, then each value in \code{y} will be included
even if it has no matching values in \code{x}}

\item{list}{logical.  If \code{TRUE}, the result will be returned as a list of vectors, each vector being the matching values in y.
If \code{FALSE}, result is returned as a data frame with repeated values for each match.}

\item{indexes}{logical.  Whether to return the indices of the matches or the actual values.}

\item{nomatch}{the value to be returned in the case when no match is found. If not provided
and \code{indexes=TRUE}, items with no match will be represented as \code{NA}.  If set to \code{NULL},
items with no match will be set to an index value of \code{length+1}.  If
{indexes=FALSE}, they will default to \code{NA}.}
}
\description{
Returns a lookup table or list of the positions of ALL matches of its first argument in its second and vice versa.
Similar to \code{\link{match}}, though that function only returns the first match.
}
\details{
This behavior can be imitated by using joins to create lookup tables, but \code{matches} is simpler and faster: 
usually faster than the best joins in other packages and thousands of times faster than the built in \code{\link{merge}}.

\code{all.x/all.y} correspond to the four types of database joins in the following way:

\describe{
\item{left}{\code{all.x=TRUE}, \code{all.y=FALSE}}
\item{right}{\code{all.x=FALSE}, \code{all.y=TRUE}}
\item{inner}{\code{all.x=FALSE}, \code{all.y=FALSE}}
\item{full}{\code{all.x=TRUE}, \code{all.y=TRUE}}
}

Note that \code{NA} values will match other \code{NA} values.
}
\examples{
one<-as.integer(1:10000)
two<-as.integer(sample(1:10000,1e3,TRUE))
system.time(a<-lapply(one, function (x) which(two \%in\% x)))
system.time(b<-matches(one,two,all.y=FALSE,list=TRUE))

one<-round(runif(1e3),3)
two<-round(runif(1e3),3)
system.time(a<-lapply(one, function (x) which(two \%in\% x)))
system.time(b<-matches(one,two,all.y=FALSE,list=TRUE))
 
one<-as.character(1:1e5)
two<-as.character(sample(1:1e5,1e5,TRUE))
system.time(b<-matches(one,two,list=FALSE))
system.time(c<-merge(data.frame(key=one),data.frame(key=two),all=TRUE))
 
\dontrun{
one<-as.integer(1:1000000)
two<-as.integer(sample(1:1000000,1e5,TRUE))
system.time(b<-matches(one,two,indexes=FALSE))
if(requireNamespace("dplyr",quietly=TRUE))
 system.time(c<-dplyr::full_join(data.frame(key=one),data.frame(key=two)))
if(require(data.table,quietly=TRUE))
 system.time(d<-merge(data.table(data.frame(key=one))
             ,data.table(data.frame(key=two))
             ,by='key',all=TRUE,allow.cartesian=TRUE))

one<-as.character(1:1000000)
two<-as.character(sample(1:1000000,1e5,TRUE))
system.time(a<-merge(one,two)) #Times out
system.time(b<-matches(one,two,indexes=FALSE))
if(requireNamespace("dplyr",quietly=TRUE))
 system.time(c<-dplyr::full_join(data.frame(key=one),data.frame(key=two)))#'
if(require(data.table,quietly=TRUE))
{
 system.time(d<-merge(data.table(data.frame(key=one))
             ,data.table(data.frame(key=two))
             ,by='key',all=TRUE,allow.cartesian=TRUE))
 identical(b[,1],as.character(d$key))
}
}
}

