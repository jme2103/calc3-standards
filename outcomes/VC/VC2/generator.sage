class Generator(BaseGenerator):
    def data(self):

        var('x y t')

        ############ code for task 1 ##############

        # choose a random sign for the line integral
        intvalue=choice(['positive', 'negative', 'zero'])
        
        # choose randomly between 
        # 0 - circular vector field
        # 1 - constant vector field
        scenario=randint(0,1)
        
        if scenario==0:
            Gx=-y/(x^2+y^2)^(1/2)
            Gy=x/(x^2+y^2)^(1/2)

            
            c=choice([1, 1.2, 0.8])     # what does c control? ellipticity?
            k=randint(3,7)
            theta0=randint(-10,10)/10
            if intvalue=='positive':
                rx(t)=k*cos(pi*(t+theta0))
                ry(t)=c*k*sin(pi*(t+theta0))
            if intvalue=='negative':
                rx(t)=k*cos(pi*((1-t)+theta0))
                ry(t)=c*k*sin(pi*((1-t)+theta0))
            if intvalue=='zero':
                x0=randint(1, 7)*choice([-1,1])
                y0=randint(1, 7)*choice([-1,1])
                rx(t)=-x0+2*x0*t
                ry(t)=-y0+2*y0*t
            
            
            
        if scenario==1:
            dx=randint(3,5)
            dy=randint(3,5)
            signx=choice([-1,1])
            signy=choice([-1,1])
            Gx=dx/5*signx
            Gy=dy/5*signy
            
            if intvalue=='positive':
                x0=randint(-7,-3)*signx
                y0=randint(-7,-3)*signy
                x1=randint(3,7)*signx
                y1=randint(3,7)*signy
                rx(t)=(x0+(x1-x0)*t)
                ry(t)=(y0+(y1-y0)*t)
            if intvalue=='negative':
                x0=randint(-7,-3)*signx*(-1)
                y0=randint(-7,-3)*signy*(-1)
                x1=randint(3,7)*signx*(-1)
                y1=randint(3,7)*signy*(-1)
                rx(t)=(x0+(x1-x0)*t)
                ry(t)=(y0+(y1-y0)*t)    
            if intvalue=='zero':
                x0=randint(-5,-1)*signx
                y0=randint(-5,-1)*signy*(-1)
                x1=-1*x0
                y1=y0+(x1-x0)*(-1)*Gx/Gy
                rx(t)=(x0+(x1-x0)*t)
                ry(t)=(y0+(y1-y0)*t) 
                
            
        
        P=(rx(0), ry(0))
        Q=(rx(1), ry(1))
        R=(rx(0.95), ry(0.95))      # used for placing the arrowhead

        ############ code for task 2 ##############

        # make a couple of random intergers not both zero
        [m,n]=[0,0]
        while(m*n==0):
            [m,n]=[randint(-3,3),randint(1,2)]
        
        # a collection of expressions to build a vector field from
        exprs=[
                m,
                n,
                m*x,
                n*y,
                m*x*y,
                m*x + n*y,
                x^n,
                y^n,
                m*x^n*y,
                m*x*y^n,
            ]

        # randomly choose fx and fy ensuring the field is not conservative
        fx(x,y) = 1
        fy(x,y) = 1
        while(fy(x,y).derivative(x)-fx.derivative(y)==0):
            [i,j]=[2*randint(0,4),2*randint(0,4)+1]
            
            fx(x,y) = 2*exprs[i]
            fy(x,y) = 2*exprs[j]
        
        # randomly choose a start and end point for path
        p = vector((0,0))
        q = vector((0,0))
        while(p==q):
            p = vector((randint(-4,4),randint(-4,4)))        
            q = vector((randint(-4,4),randint(-4,4)))
        
        # choose a random scenario
        # True - line segment
        # False - semicircle
        if(choice([True,False])):
            [ta,tb]=[0,1]
            r(t) = vector((1-t)*p + t*q)
            rr(t)= [r(t)[0].derivative(t),r(t)[1].derivative(t)]
            integrand = fx(r(t)[0],r(t)[1])*rr(t)[0]+fy(r(t)[0],r(t)[1])*rr(t)[1]
            result = integrate(integrand, t, ta, tb)
            ctype = "line segment"
        else:
            k=choice([0,1,2,3]) # North, south, east, west semicircle
            if(k<=1): #north or south
                p = vector((-1*randint(1,4),randint(-4,4)))
                q = vector((-1*p[0],p[1]))
                ta=0
                tb=pi
                radius = abs(p[0])
                r(t) = [radius*cos(t),(-1)^k*radius*sin(t)+p[1]]
                rr(t)= [r(t)[0].derivative(t),r(t)[1].derivative(t)]
                integrand = fx(r(t)[0],r(t)[1])*rr(t)[0]+fy(r(t)[0],r(t)[1])*rr(t)[1]
                result = integrate(integrand, t, ta, tb)
                if(k==0):
                    ctype = "upper half of the semicircle"
                if(k==1):
                    ctype = "lower half of the semicircle"
            if(k>=2): #east or west
                p = vector((randint(-4,4),randint(1,4)))
                q = vector((p[0],-1*p[1]))
                ta=0
                tb=pi
                radius = abs(p[1])
                r(t) = [p[0]+(-1)^k*radius*sin(t),radius*cos(t)]
                rr(t)= [r(t)[0].derivative(t),r(t)[1].derivative(t)]
                integrand = fx(r(t)[0],r(t)[1])*rr(t)[0]+fy(r(t)[0],r(t)[1])*rr(t)[1]                
                result = integrate(integrand, t, ta, tb)
                if(k==2):
                    ctype = "right half of the semicircle"
                if(k==3):
                    ctype = "left half of the semicircle"
            
            
            
            
        return {
            # data for task 1
            "Gx": Gx,
            "Gy": Gy,
            "task1rx": rx(t),
            "task1ry": ry(t),
            "intvalue": intvalue,
            "P": P,
            "Q": Q,
            "R": R,

            # data for task 2
            "fx": fx(x,y),
            "fy": fy(x,y),
            "rx": r(t)[0],
            "ry": r(t)[1],
            "ctype": ctype,
            "ta": ta,
            "tb": tb,
            "p": p,
            "q": q,
            "integrand": integrand,
            "result": result
        }
    
    @provide_data
    def graphics(data):
    # updated by clontz
        return {"task1plot":plot_vector_field((data['Gx'], data['Gy']), (x,-10,10),(y,-10,10), color=['blue'])+parametric_plot( (data['task1rx'], data['task1ry']), (t, 0, 1), color='red', thickness=2, )+point(data['P'],color='red', size=30)+point(data['Q'],color='red', size=30)+text("$P$", (data['P'][0]+0.2, data['P'][1]), horizontal_alignment='left', color='red')+text("$Q$", (data['Q'][0]-0.2, data['Q'][1]), horizontal_alignment='right', color='red')+arrow(data['R'], data['Q'], color='red'),
                "plot": plot_vector_field((data['fx'],data['fy']),(x,-5,5),(y,-5,5))+parametric_plot((data['rx'],data['ry']),(t,data['ta'],data['tb']))+point(data['p'],size=24)+point(data['q'],size=24)+text(' $P(%s,%s)$'%(data['p'][0],data['p'][1]),data['p'],horizontal_alignment="left",vertical_alignment="top")+text(' $Q(%s,%s)$'%(data['q'][0],data['q'][1]),data['q'],horizontal_alignment="left",vertical_alignment="bottom")
            }