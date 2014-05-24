Rule.delete_all
Fact.delete_all

Fact.new.build('_____(GEOGRAPHIA)').save
Fact.new.build('more_populated(molodechno,smorgon)').save
Fact.new.build('more_populated(borisov,molodechno)').save
Fact.new.build('more_populated(belarus,georgia)').save
Fact.new.build('more_populated(china,belarus)').save

Fact.new.build('city(belarus,smorgon)').save
Fact.new.build('city(belarus,molodechno)').save

Fact.new.build('capital(belarus,minsk)').save
Fact.new.build('capital(china,pekin)').save
Fact.new.build('capital(georgia,tbilisi)').save

Rule.new.build('_____(_)<-_____(GEOGRAPHIA)').save
Rule.new.build('more_populated(X,Z)<-more_populated(X,Y);more_populated(Y,Z)').save
Rule.new.build('more_populated(X,Y)<-capital(X,Y)').save
Rule.new.build('more_populated(S1,S2)<-capital(X,S1);capital(Y,S2);more_populated(X,Y)').save
Rule.new.build('more_populated(X,Y)<-more_populated(X,S1);city(S1,Y)').save
Rule.new.build('more_populated(S1,S2)<-more_pDopulated(S1,Y);city(Y,S2)').save

Fact.new.build('_____(POETES)').save

Fact.new.build('PISHETPLOHO(gogol)').save
Fact.new.build('PISHETNORM(turgenev)').save

Rule.new.build('_____(_)<-_____(POETES)').save
Rule.new.build('UMNEE(X,Y)<-PISHETLUCHSHE(X,Y)').save
Rule.new.build('PISHETLUCHSHE(X,Y)<-UMNEE(X,Y)').save
Rule.new.build('UMNEE(X,Y)<-PISHETNORM(X);PISHETPLOHO(Y)').save

Fact.new.build('_____(P)').save

Fact.new.build('P(a,d)').save
Fact.new.build('P(a,b)').save
Fact.new.build('P(d,e)').save
Fact.new.build('Q(b,c)').save
Fact.new.build('Q(b,d)').save
Fact.new.build('L(e,e)').save
Fact.new.build('L(s,k)').save

Rule.new.build('_____(_)<-_____(P)').save
Rule.new.build('R(X,Y)<-P(X,Z);Q(Z,Y)').save
Rule.new.build('Q(A,B)<-L(A,A);L(B,B)').save
