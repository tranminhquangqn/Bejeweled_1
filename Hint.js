function findHint() {
    var i,j
    var found=[]
    console.log("ggregrggg")
//find row
    for(i=0;i<gridBg.rows-1;i++)
    {
        for(j=0;j<gridBg.columns-2;j++)
        {
            if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+2).children[0].source)
            {
                  return [gridBg.columns*i+j,gridBg.columns*(i+1)+j]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+2).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source)
            {
                  return [gridBg.columns*i+j+1,gridBg.columns*(i+1)+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j+2).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+2).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source)
            {
                  return [gridBg.columns*i+j+2,gridBg.columns*(i+1)+j+2]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*i+j+2).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source)
            {
                  return [gridBg.columns*i+j,gridBg.columns*(i+1)+j]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+2).children[0].source)
            {
                  return [gridBg.columns*i+j+1,gridBg.columns*(i+1)+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*i+j+1).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+2).children[0].source)
            {
                  return [gridBg.columns*i+j+2,gridBg.columns*(i+1)+j+2]
            }
        }
    }
//find col
    for(i=0;i<gridBg.rows-2;i++)
    {
        for(j=0;j<gridBg.columns-1;j++)
        {
            if(rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+2)+j).children[0].source)
            {
                  return [gridBg.columns*i+j,gridBg.columns*i+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source)
            {
                  return [gridBg.columns*(i+1)+j,gridBg.columns*(i+1)+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+2)+j+1).children[0].source)
            {
                  return [gridBg.columns*(i+2)+j,gridBg.columns*(i+2)+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+2)+j+1).children[0].source)
            {
                  return [gridBg.columns*i+j,gridBg.columns*i+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j).children[0].source===rpItem.itemAt(gridBg.columns*(i+2)+j).children[0].source)
            {
                  return [gridBg.columns*(i+1)+j,gridBg.columns*(i+1)+j+1]
            }
            else if(rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+1)+j+1).children[0].source
                    &&rpItem.itemAt(gridBg.columns*i+j+1).children[0].source===rpItem.itemAt(gridBg.columns*(i+2)+j).children[0].source)
            {
                  return [gridBg.columns*(i+2)+j,gridBg.columns*(i+2)+j+1]
            }

        }
    }
}
