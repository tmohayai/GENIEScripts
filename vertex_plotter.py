# quick validation script for genie ghep files after their conversion to gst format
# coordinate limits in the histogram are based on ND-GAr fiducial volume; change them, as needed. 

import ROOT
import os.path

hist_xy = ROOT.TH2D("xy",";x [m]; y [m]",100,-4.2,4.2,100,-5.5,2.5)
hist_xz = ROOT.TH2D("xz",";z [m]; y [m]",100,10.0,19.0,100,-4.2,4.2)
hist_yz = ROOT.TH2D("yz",";z [m]; y [m]",100,10.0,19.0,100,-5.2,2.2) 

# change the upper limit of the loop variable i, as needed

for i in range(1,101):
        f = ROOT.TFile.Open("neutrino."+str(i)+".gst.root")
	if os.path.exists("neutrino."+str(i)+".gst.root"):
		print i
		for event in f.gst:
			for nfs in range(0,event.nf):				
				x = event.vtxx
				y = event.vtxy
				z = event.vtxz
				hist_xy.Fill(x,y) 
				hist_xz.Fill(z,x)
				hist_yz.Fill(z,y)

g = ROOT.TGraph()

c = ROOT.TCanvas()
hist_xy.Draw('colz')
hist_xy.SetStats(0);
c.Print("xy.png")

c_2 = ROOT.TCanvas()
hist_xz.Draw('colz')
hist_xz.SetStats(0);
c_2.Print("xz_2.png")

c_3 = ROOT.TCanvas()
hist_yz.Draw("colz");
hist_yz.SetStats(0);
c_3.Print("yz.png")

