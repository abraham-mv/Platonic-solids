#include	"colors.inc"		
#include	"textures.inc"	
#include	"shapes.inc"


camera{
location <7,5.5,4>/1.5   
look_at <-0.5,0,0>}

light_source {
<1000,0, 0>
color	White}
  
light_source {
<0,1000, -1000>
color	White} 
background { color rgb< 1, 1, 1> } 


#fopen Salida  "solidos.xyz" write
//#fopen Salida1 "dode2.xyz" write
//#fopen Salida2 "octaedro.xyz" write

//#write ( Salida1,"20  ", "\n") 
//#write ( Salida1, "Dodecaedro","\n")  

//Se declaran radios para esferas y cilindros y las texturas
#declare Rs=0.15;    
#declare Rc=0.1;
#declare Rc1=0.03;
#declare ts= texture{ pigment{color Blue}};  
#declare tc= texture{ pigment{color Green}};
#declare tc1= texture{ pigment{color Red}};
#declare tc2 = texture{ pigment{color Gray}};
#declare tc3 = texture{ pigment{color Yellow}};
#declare tc4 = texture{ pigment{color Black}};

#declare a=2;
#declare n=20;
#declare d=a*0.618;  
#declare octa = array[7];

#declare V=array[n];
#declare V[0]=<a/2, a/2, a/2>;    
#declare V[1]=<-a/2, -a/2, -a/2>; 
#declare V[2]=<-a/2, a/2, a/2>;   
#declare V[3]=<a/2, -a/2, a/2>;   
#declare V[4]=<a/2, a/2, -a/2>;   
#declare V[5]=<-a/2, -a/2, a/2>;  
#declare V[6]=<-a/2, a/2, -a/2>;  
#declare V[7]=<a/2, -a/2, -a/2>; 
 

//Se declaran las posiciones del ico
#declare V[8] = a/2*< 0    ,     1 , -0.618>;
#declare V[9] = a/2*< 0    ,     1 ,  0.618>;
#declare V[10] = a/2*< 1    ,  0.618,  0,   >;
#declare V[11] = a/2*< 1    , -0.618,  0,   >;
#declare V[12] = a/2*< 0.618,     0 ,     1,>;
#declare V[13] = a/2*<-0.618,     0 ,     1,>;
#declare V[14] = a/2*< 0.618,     0 ,    -1,>;
#declare V[15] = a/2*<-0.618,     0 ,    -1,>;
#declare V[16] = a/2*< 0    ,    -1 , -0.618>;
#declare V[17] = a/2*< 0    ,    -1 ,  0.618>;
#declare V[18] = a/2*<-1    , -0.618,  0,   >;
#declare V[19] = a/2*<-1    ,  0.618,  0,   >;

//***************Tetraedro*************************************************
//Se declara un arreglo para las posiciones del tetraedro y se le da como valor inicial la Pos[0] del cubo
#declare tetra=array[4];
#declare tetra[0]=V[0];
 
#sphere{tetra[0], Rs pigment{color Blue}}

#write (Salida, "Au  ",vstr(3, tetra[0],   " ",  0,3), "\n")

//Se define un sólo ciclo para obtener los vértices del tetraedro basándonos en el punto Pos[0]
#declare i=1;
#declare counter=1;  //se declara un contado para las posiciones del tetraedro
#while (i<8)
        #declare L=VDist(V[0],V[i]);
        //Los vértices del tetraedro deben estar a a*sqrt(2) de distancia:               
        #if((L<a*sqrt(2)+0.1)& L>a & counter<4)  //se le añade añade al condicional que el contador sea menor a 4
            #declare tetra[counter]=V[i];
            sphere {tetra[counter], Rs pigment{color Blue}}   
            #write (Salida, "Au  ",vstr(3, tetra[counter],   " ",  0,3), "\n") 
            #declare counter=counter+1;
        #end
    #declare i=i+1;
 #end
  
//Se declara un ciclo para imprimir los enlaces del tetraedro 
#declare i=0;
#declare k=0;
#while(i<counter)
    #declare j=i+1;
    #while(j<counter)
        cylinder{tetra[i],tetra[j], Rc1 texture{tc1} finish{phong 1}} 

//***********Ocatedro************************                            
        #declare octa[k]=(tetra[j]+tetra[i])/2;
        sphere {octa[k], Rs texture{tc3} finish{phong 1}}
        #write(Salida,"Ag", " " ,vstr(3,octa[k]," ",5,7),"\n")
        #declare k=k+1;
        #declare j=j+1;
    #end
    #declare i=i+1;
#end 

#for(i,0,k-1,1)
    #for(j,i+1,k-1,1)
        #if(VDist(octa[i],octa[j]) < a/sqrt(2) + 0.01)
            cylinder{octa[i],octa[j], Rc1 texture{tc3} finish{phong 1}}
        #end  
    #end
#end

//**************************Cubo e icosaedro**********************
//Se lee el archivo que contiene a las posiciones del cubo y las del ico
#declare i=0;
#while (i<20)    
        sphere{V[i] Rs texture {ts} finish{phong 1}}
        #write(Salida,"Cu", " " ,vstr(3,V[i]," ",5,7),"\n")
    #declare i=i+1;
#end

//Se imprimen los enlaces del cubo
#declare i=0;
#while (i<8)
    #declare j=i+1;
    #while (j<8)
        #if (VDist(V[j],V[i]) < a+0.01)
            cylinder {V[j],V[i] Rc1 texture{ts} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end

//Se imprimen los enlaces del icosaedro
#declare i=8;
#while (i<20)
    #declare j=i+1;
    #while (j<20)
        #if (VDist(V[j],V[i]) < d+0.01)
            cylinder {V[j],V[i] Rc1 texture{tc4} finish{phong 1}}
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end

//*************************Dodecaedro************************
//En esta parte del código se desplazan las posiciones del ico para formar un dodecaedro
#declare i=0;
#while (i<8)
    
    #declare j=i+1;
    #while(j<8)
        
        #if(VDist(V[i],V[j])<a+0.1) //Se pregunta si ambas posiciones del cubo forman una arista
            
            #declare k=8;
            #while (k<n)
                
                #if(VDist(V[k],V[i])<d & VDist(V[k],V[j])<d) //Se pregunta si la posición del ico está cerca de la arista
                    
                    #declare d2=0;
                    #declare h=0;
                    #declare vector_des = VPerp_To_Plane(V[j]-V[k],V[i]-V[k]); //se declara el vector desplazamiento
                    
                    #if (vdot(vector_des,V[k])<0)          //Este if sirve para saber si el vector desplazamiento va hacia afuera de la cara o hacia adentro
                        #declare vector_des = -vector_des; //Si el vector está hacia adentro se cambia el sentido del vector
                    #end
                    
                    #while (d2<d)
                        #declare V[k]=V[k]+h*vector_des; //Se hace la operación para desplazar a la posición del ico
                        #declare d2 = VDist(V[k],V[i]);
                        #declare h = h + 0.01;
                    #end
                    
                    sphere{V[k] Rs texture{tc} finish{phong 1}}
                    #write(Salida,"C", " " ,vstr(3,V[k]," ",5,7),"\n")
                
                #end
                #declare k=k+1;
            #end
        #end
        #declare j=j+1;
    #end
    #declare i=i+1;
#end

#declare enlaces=
union {
    #declare i=0;
    #while (i<n)
        #declare j=i+1;
        #while (j<n)
            #declare d3=VDist(V[i],V[j]);
            #if (d3>=d & d3<a)
                cylinder {V[i],V[j] Rc1 texture{tc} finish{phong 1}}    
            #end
            #declare j=j+1;    
        #end
        #declare i=i+1;
    #end
}
object{enlaces} 