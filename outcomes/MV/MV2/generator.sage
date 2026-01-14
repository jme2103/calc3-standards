class Generator(BaseGenerator):
    def data(self):
        x=var("x")
        y=var("y")
        t=var("t")
        
        
        
        mag=0
        
        while(mag==0 or mag==1):
            v=[randint(-5,5), randint(-5,5), randint(-5,5)]
            w=[randint(-5,5), randint(-5,5), randint(-5,5)]
            
            a=randint(1,3)*choice([-1,1])
            b=randint(1,3)
        
            case = choice([-1,1])

            # variables needed to pass to graphics
            
            plane = ""
            horiz_axis = ""
            vert_axis = ""
            two_d_v = vector([0,0])
            two_d_w = vector([0,0])
            two_d_sum = vector([0,0])
        
            if case == 1:
                op = '+',
                initp = "the origin"
                termp = "the resultant of placing the tail of "+str(b)+"w at the head of "+str(a)+"v"
        
            if case == -1:
                op = '-'
                initp = "the head of "+str(b)+"w"
                termp = "the tail of "+str(a)+"v"
            
            u= [0,0,0]
            for i in range(3):
                u[i]=a*v[i]+case*b*w[i]
            mag=(u[0]^2+u[1]^2+u[2]^2)^(1/2)
            if mag!=0:
                unitu=[u[0]/mag, u[1]/mag, u[2]/mag]
            
            # do task 4 - projections
            scenario = randint(0,2)
            if scenario == 0:
                # project on yz-plane
                plane = "yz"
                horiz_axis = "$y$"
                vert_axis = "$z$"
                two_d_v = vector([v[1], v[2]])
                two_d_w = vector([w[1], w[2]])
                two_d_sum = two_d_v + two_d_w
            elif scenario == 1:
                # project on xz-plane
                plane = "xz"
                horiz_axis = "$x$"
                vert_axis = "$z$"
                two_d_v = vector([v[0], v[2]])
                two_d_w = vector([w[0], w[2]])
                two_d_sum = two_d_v + two_d_w
            else:
                # project on xy-plane
                plane = "xy"
                horiz_axis = "$x$"
                vert_axis = "$y$"
                two_d_v = vector([v[0], v[1]])
                two_d_w = vector([w[0], w[1]])
                two_d_sum = two_d_v + two_d_w
            
            
        
        

        
        #surface = x^2+y^2
        return {
            "v0": v[0],
            "v1": v[1],
            "v2": v[2],
            "w0": w[0],
            "w1": w[1],
            "w2": w[2],
            "u0": u[0],
            "u1": u[1],
            "u2": u[2],
            "unitu0": unitu[0],
            "unitu1": unitu[1],
            "unitu2": unitu[2],
            "a": a,
            "b": b,
            "mag": mag,
            "op": op,
            "vecvx": a*v[0]*t,
            "vecvy": a*v[1]*t,
            "vecvz": a*v[2]*t,
            "vecux": u[0]*t,
            "vecuy": u[1]*t,
            "vecuz": u[2]*t,
            "vecwx": a*v[0]+case*b*w[0]*t,
            "vecwy": a*v[1]+case*b*w[1]*t,
            "vecwz": a*v[2]+case*b*w[2]*t,
            "initp": initp,
            "termp": termp,
            
            "plane": plane,
            "horiz_axis": horiz_axis,
            "vert_axis": vert_axis,
            "two_d_vx": two_d_v[0],
            "two_d_vy": two_d_v[1],
            "two_d_wx": two_d_w[0],
            "two_d_wy": two_d_w[1],
            "two_d_sumx": two_d_sum[0],
            "two_d_sumy": two_d_sum[1]
        }

    @provide_data
    def graphics(data):
        return {"2dplot": plot(vector([data['two_d_vx'],data['two_d_vy']]), color='blue', aspect_ratio='automatic', figsize=6, axes_labels=[data['horiz_axis'],data['vert_axis']] ) + plot(vector([data['two_d_vx'],data['two_d_vy']]), color='blue', linestyle='--',start=(data['two_d_wx'],data['two_d_wy']) ) + plot(vector([data['two_d_wx'],data['two_d_wy']]), color='red') + plot(vector([data['two_d_wx'],data['two_d_wy']]), color='red', linestyle=':',start=(data['two_d_vx'],data['two_d_vy'])) + plot(vector([data['two_d_sumx'],data['two_d_sumy']]), color='purple')
        }