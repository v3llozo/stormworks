sb=output.setBool
sn=output.setNumber
gn=input.getNumber
gb=input.getBool
sc=screen.setColor
dtb=screen.drawTextBox
drf=screen.drawRectF
dr=screen.drawRect
dl=screen.drawLine
sf=string.format
t=true
f=false
rwps=15
wps=15
thr=0.2

function onTick()	
    iP=gb(1)
    inX=gn(3)
    inY=gn(4)
    w=gn(1)
    h=gn(2)
    ovr=gb(3)
    ge1=gb(4)
    ge2=gb(5)
    igni=gb(6)
    st=gb(7)
    ca=gb(8)
    owps=gb(9)
    
    wpsp=iP and InR(inX,inY,0,0,w/4,h/8)
    wpsm=iP and InR(inX,inY,0,h*7/8,w/4,h/8)
    thrp=iP and InR(inX,inY,w*3/4,0,w/4,h/8)
    thrm=iP and InR(inX,inY,w*3/4,h*7/8,w/4,h/8)
    start=iP and InR(inX,inY,w/4,0,w/2,h/6)
    override=iP and InR(inX,inY,w/4,h/6,w/2,h/6)
    g1=iP and InR(inX,inY,w/4,h/3,w/2,h/6)
    g2=iP and InR(inX,inY,w/4,h/2,w/2,h/6)
    ign=iP and InR(inX,inY,w/4,h*2/3,w/2,h/6)
    cam=iP and InR(inX,inY,w/4,h*5/6,w/2,h/6)
    setWPS=iP and InR(inX,inY,0,h/8+7,w/4,h*3/4-15)
    setTHR=iP and InR(inX,inY,w*3/4,h/8+7,w/4,h*3/4-15)
    overWPS=iP and InR(inX,inY,w/5+2,h*7/8-7,7,7)
    if (not owps) then wps=rwps end
    if (not owps) and wpsp and (wps<60) then wps=wps+0.25 end
    if (not owps) and wpsm and (wps>=1.25) then wps=wps-0.25 end
    if thrp and thr<1 then thr=thr+1/128 end
    if thrm and thr>0 then thr=thr-1/128 end
    if setWPS then wps=((h*3/4-15)-(inY-(h/8+7)))/(h*3/4-15)*60 end
    if setTHR then thr=((h*3/4-15)-(inY-(h/8+7)))/(h*3/4-15)end
    if start then sb(5,t) else sb(5,f)end
    if override then sb(1,t) else sb(1,f)end
    if ign then sb(4,t)else sb(4,f)end
    if g1 then sb(2,t)else sb(2,f)end
    if g2 then sb(3,t)else sb(3,f)end
    if cam then sb(6,t)else sb(6,f)end
    if overWPS then sb(9,t) else sb(9,f) end
    if not owps then rwps=wps else wps=0 end
    if thr>1 then thr=1 elseif thr<0 then thr=0 end
    if wps>60 then wps=60 elseif wps<0 then wps=0 end
    sn(1,thr)
    sn(2,wps)
end	

function InR(x,y,rX,rY,rW,rH)
    return x>rX and y>rY and x<rX+rW and y<rY+rH
end

function onDraw()
    sc(0,0,0)
    drf(0,0,w,h)
    sc(3,3,3)
    drf(w/4,0,w/2,h)
    
    sc(2,20,2)
    if ovr then drf(w/4,h/6,w/2,h/6)end
    if ge1 then drf(w/4,h/3,w/2,h/6)end
    if ge2 then drf(w/4,h/2,w/2,h/6)end
    if igni then drf(w/4,h*2/3,w/2,h/6)end
    if st then drf(w/4,0,w/2,h/6)end
    if ca then drf(w/4,h*5/6,w/2,h/6)end
    if owps then drf(w/5+2,h*7/8-7,7,7)end
    
    drf(0,h*7/8-7,w/4,-wps/60*(h*3/4-14))
    drf(w*3/4,h*7/8-7,w/4,-thr*(h*3/4-14))
    
    sc(10,10,2)
    if wpsp then drf(0,0,w/4,h/8)
    elseif wpsm then drf(0,h*7/8,w/4,h/8)
    elseif thrp then drf(w*3/4,0,w/4,h/8)
    elseif thrm then drf(w*3/4,h*7/8,w/4,h/8)
    elseif start then drf(w/4,0,w/2,h/6)
    elseif override then drf(w/4,h/6,w/2,h/6)
    elseif g1 then drf(w/4,h/3,w/2,h/6)
    elseif g2 then drf(w/4,h/2,w/2,h/6)
    elseif ign then drf(w/4,h*2/3,w/2,h/6)
    elseif cam then drf(w/4,h*5/6,w/2,h/6)
    elseif overWPS then drf(w/5+2,h*7/8-7,7,7)end
    
    sc(99,99,99)
    dr(0,0,w/4,h/8-1)
    dr(0,h*7/8,w/4,h/8-1)
    dr(w*3/4,0,w/4,h/8-1)
    dr(w*3/4,h*7/8,w/4,h/8-1)
    dr(w/4,0,w/2,h/6)
    dr(w/4,h/6,w/2,h/6)
    dr(w/4,h/3,w/2,h/6)
    dr(w/4,h/2,w/2,h/6)
    dr(w/4,h*2/3,w/2,h/6)
    dr(w/4,h*5/6,w/2,h/6-1)
    dl(w/5+1,h*7/8-7,w/5+1,h*7/8)
    dr(0,h/8+7,w/4,h*3/4-15)
    dr(w*3/4,h/8+7,w/4,h*3/4-15)
    
    sc(200,150,50)
    dtb(0,0,w/4,h/8,"WRIT/S+",0,0)
    dtb(0,h*7/8,w/4,h/8,"WRIT/S-",0,0)
    dtb(w*3/4,0,w/4,h/8,"THRTL+",0,0)
    dtb(w*3/4,h*7/8,w/4,h/8,"THRTL-",0,0)
    dtb(w/4,0,w/2,h/6,"Start",0,0)
    dtb(w/4,h/6,w/2,h/6,"Manual",0,0)
    dtb(w/4,h/3,w/2,h/6,"Gearbox Up",0,0)
    dtb(w/4,h/2,w/2,h/6,"Gearbox Down",0,0)
    dtb(w/4,h*2/3,w/2,h/6,"Ignition",0,0)
    dtb(w/4,h*5/6,w/2,h/6,"BG Video",0,0)
    
    dtb(w*3/4,h/8,w/4,7,"Max:1.0",0,0)
    dtb(w*3/4,h*7/8-7,w/4,7,"Min:0.0",0,0)
    dtb(0,h/8,w/4,7,"Max:60",0,0)
    dtb(0,h*7/8-7,w/5,7,"Min:1",0,0)
    dtb(w/5+2,h*7/8-7,7,7,"0",0,0)
    
    dtb(0,h/8+7,w/4,h*3/4-14,sf("%.f",wps),0,0)
    dtb(w*3/4,h/8+7,w/4,h*3/4-14,sf("%.2f",thr),0,0)
end