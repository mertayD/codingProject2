LMSquareLossL2CV <- function(
  X.mat, 
  y.vec, 
  fold.vec, 
  penalty.vec
  ){
  for (fold.i in fold.vec){
    validation_indices <- which(fold.vec %in% c(fold.i))
    validation_set <- X.mat[validation_indices,]
    train_set <- X.mat[-validation_indices,]
    train_labels <- y.vec[-validation_indices]
    validation_labels <- y.vec[validation_indices] 
    n_rows_validation_set <- nrow(validation_set)
    n_rows_train_set <- nrow(train_set)
    
    W <- LMSquareLossL2Penalties(train_set,train_labels,penalty.vec)
    for(prediction.set.name in c("train", "validation")){
      if(identical(prediction.set.name, "train")){
        to.be.predicted <- train_set
      }
      else{
        to.be.predicted <- validation_set
      }
      
      pred <- to.be.predicted %*% W 
      
      if(identical(prediction.set.name, "train")){
        loss.mat <- (sweep(pred,2, as.vector(validation_labels),"-"))^2
        train.loss.mat[,fold.i] <- colMeans(loss.mat)
      }
      else{
        loss.mat <- (sweep(pred,2, as.vector(train_labels),"-"))^2
        validation.loss.mat[,fold.i] <- colMeans(loss.mat)
      }
    }
  }
  #To be returned
  mean.validation.loss.vec <- colMeans(validation.loss.mat)
  mean.train.loss.vec <- colMeans(train.loss.mat)
  #don't forget to return penalty.vec for plot
  selected.penalty <- which.min(mean.validation.loss.vec)
  w.vec <- LMSquareLossL2Penalties(X.mat,y.vec,penalty.vec)
  index <- which(penalty.vec %in% c(selected.penalty))
  weight_vec <- w.head[,index]
  
}