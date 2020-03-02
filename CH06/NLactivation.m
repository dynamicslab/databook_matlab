function E=NLactivation(A,train,label)
E= norm(label - 1./(1+exp(-A*train)));
